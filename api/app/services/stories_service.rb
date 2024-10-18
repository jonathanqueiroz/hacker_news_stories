require 'concurrent'
require 'redis'

class StoriesService
  attr_reader :cache, :http_client

  def initialize(cache: $redis, http_client: HTTParty)
    @cache = cache
    @http_client = http_client
  end

  def get_stories(stories_type = 'top', filter_term = nil)
    if filter_term.blank?
      cache_key = "#{stories_type}_stories"
      cached_stories = cache.get(cache_key)

      return JSON.parse(cached_stories) if cached_stories.present?
    end

    story_ids = fetch_story_ids(stories_type)

    stories = fetch_stories(story_ids)

    return stories if stories.blank?

    stories = filter_by_term(stories, filter_term) if filter_term.present?

    sorted_stories = sort_stories_by_date(stories)

    if filter_term.blank?
      cache_object(cache_key, 120, sorted_stories)

      ActionCable.server.broadcast('stories_channel', { stories: sorted_stories })
    end

    sorted_stories
  end

  def get_story(id)
    cache_key = "story_#{id}"
    cached_story = cache.get(cache_key)

    return JSON.parse(cached_story) if cached_story.present?

    story = fetch_story(id)

    return story if story.blank?

    fetched_story = build_story(story, id)

    cache_object(cache_key, 60, fetched_story)

    fetched_story
  end

  def get_comments(id)
    story = get_story(id).with_indifferent_access

    raise 'Story not found' if story.blank?

    fetch_comments(story['kids'])
  end

  private

  def fetch_story_ids(stories_type)
    if stories_type == 'top'
      response = http_client.get('https://hacker-news.firebaseio.com/v0/topstories.json')
    else
      response = http_client.get('https://hacker-news.firebaseio.com/v0/newstories.json')
    end

    return [] if response.code != 200

    body = JSON.parse(response.body).compact.uniq

    stories_type == 'top' ? body.first(15) : body.first(20)
  end

  def fetch_story(id)
    response = http_client.get("https://hacker-news.firebaseio.com/v0/item/#{id}.json")

    return {} if response.code != 200

    JSON.parse(response.body)
  end

  def fetch_stories(story_ids)
    executor = create_executor
    futures = story_ids.map { |id| fetch_story_future(id, executor) }
    futures.map(&:value).compact
  end

  def fetch_story_future(id, executor)
    Concurrent::Future.execute(executor: executor) do
      story = get_story(id)
      story unless story.blank?
    end
  end

  def sort_stories_by_date(stories)
    stories.sort_by { |story| story['date'] }.reverse
  end

  def filter_by_term(stories, filter_term)
    term = filter_term.downcase

    stories.filter { |story| story['title'].downcase.include?(term) }
  end

  def build_story(data, id)
    {
      id: id,
      title: data['title'],
      url: data['url'],
      by: data['by'],
      date: data['time'] ? Time.at(data['time']).iso8601 : Time.at(0).iso8601,
      kids: data['kids'] || []
    }.as_json
  end

  def fetch_comments(comment_ids)
    return [] unless comment_ids.is_a?(Array) && comment_ids.any?

    executor = create_executor
    futures = comment_ids.map { |id| fetch_comment_future(id, executor) }
    futures.compact.map(&:value).compact
  end

  def fetch_comment_future(id, executor)
    Concurrent::Future.execute(executor: executor) do
      cache_key = "comment_#{id}"
      cached_comment = cache.get(cache_key)

      if cached_comment.present?
        JSON.parse(cached_comment)
      else
        response = http_client.get("https://hacker-news.firebaseio.com/v0/item/#{id}.json")

        if response.code == 200
          data = JSON.parse(response.body)

          if data['text'].present? && data['text'].length >= 20
            comment = build_comment(data)

            cache_object(cache_key, 90, comment)

            comment
          end
        end
      end
    end
  end

  def build_comment(data)
    {
      by: data['by'],
      text: data['text'],
      date: data['time'] ? Time.at(data['time']).iso8601 : nil,
      comments: data['kids'] ? fetch_comments(data['kids']) : []
    }
  end

  def cache_object(cache_key, cache_expiration, object)
    cache.set(cache_key, object.to_json)
    cache.expire(cache_key, cache_expiration)
  end

  def create_executor
    Concurrent::ThreadPoolExecutor.new(
      min_threads: 2,
      max_threads: 10,
      max_queue: 20,
      fallback_policy: :caller_runs
    )
  end
end
