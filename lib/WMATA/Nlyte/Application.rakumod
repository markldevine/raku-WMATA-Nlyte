unit class WMATA::Nlyte::Application:ver<0.0.1>:auth<Mark Devine (mark@markdevine.com)>;

use Cro::HTTP::Router;
use Cro::HTTP::Client;
use Redis;

has $.redis;

submethod TWEAK {
    $!redis = Redis.new("127.0.0.1:6379");
}

my $http-client = Cro::HTTP::Client.new(
    content-type => 'application/json',
    headers => [ User-agent => 'Cro' ]
);

method routes () {
    route {
        get -> 'HIPH'       { content 'text/json', self.redis.get('HIPH'); }
    }
}

=finish
