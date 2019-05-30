#!/usr/bin/env perl 
#===============================================================================
#
#         FILE: test.pl
#
#        USAGE: ./test.pl  
#
#  DESCRIPTION: 
#
#      OPTIONS: ---
# REQUIREMENTS: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: YOUR NAME (), 
# ORGANIZATION: 
#      VERSION: 1.0
#      CREATED: 05/29/2019 12:33:30 PM
#     REVISION: ---
#===============================================================================

use strict;
use warnings;
use utf8;

use lib("../src");
use Data::Dumper;

use OAuth;

####DEFAULTS############
my $client_id='public-api-preview';
my $client_secret='4HJGRffVR8xb3XdEUQpjgZ1VplJi6Xgw';
my $username='tadoapi@nurfuerspam.de';
my $password='true2019';
my $scope='home.user';
my $AuthURL = qq{https://auth.tado.com/oauth/token};
my $DataURL = qq{https://my.tado.com/api/v2/me};
my $QueryURL = qq{https://my.tado.com/api/v2/homes};
my $tokenFile = "/tmp/tadotoken";
my $header = {};
my $verbose = 0;
my $help = 0;
my $data = {};
my $TokenData = {};

my $outhReq=OAuth->new({
					"METHOD"=>"POST",
					"AUTH_URL"=>$AuthURL,
					"DATA"=>{
						client_id => $client_id,
            			client_secret => $client_secret,
            			username => $username,
            			password => $password,
            			scope => $scope,
            			grant_type=>'password'
					}
				});

			#print $outhReq->getAuthURL."\n";
			#print $outhReq->getData."\n";

my $tokenData = $outhReq->requestOAuthToken();
#print "Access Token: ".$tokenData->{'access_token'}."\n";

$outhReq->setToken($tokenData);
$outhReq->addHeader({"Content-Type"=>"application/json;charset=UTF-8","Authorization"=>"$tokenData->{token_type} $tokenData->{access_token}"});
$outhReq->setMethod("GET");
print "DATA: ".Dumper($outhReq->getData($DataURL))."\n";
