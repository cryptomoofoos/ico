password = ENV['REDIS_PASS']
$redis = Redis.new(password: password, path: '/var/run/redis/redis.sock')
