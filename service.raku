#!/usr/bin/env raku

use Cro::HTTP::Log::File;
use Cro::HTTP::Server;
use WMATA::Nlyte::Application;

$*OUT.out-buffer = 0;

#%*ENV<NLYTE_HOST> = <CTUNIXVMADMINPv.wmata.local>;
%*ENV<NLYTE_HOST> = <localhost>;
%*ENV<NLYTE_PORT> = 22222;

my WMATA::Nlyte::Application $application .= new;

my Cro::Service $http = Cro::HTTP::Server.new(
    http => <1.1>,
    host => %*ENV<NLYTE_HOST> || die("Missing NLYTE_HOST in environment"),
    port => %*ENV<NLYTE_PORT> || die("Missing NLYTE_PORT in environment"),
    application => $application.routes,
    after => [ Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR) ]
);
$http.start;
say "Listening at http://%*ENV<NLYTE_HOST>:%*ENV<NLYTE_PORT>";
react {
    whenever signal(SIGHUP) {
        say "Hanging up...";
        $http.stop;
        done;
    }
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}
