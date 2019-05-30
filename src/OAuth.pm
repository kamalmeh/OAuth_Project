package OAuth;
#
#===============================================================================
#
#         FILE: OAuth.pm
#
#  DESCRIPTION: Perl Module to provide support for OAuth Authentication System.
#               Initially, request is sent to get the authentication token.
#               Once the token is retrieved, it can be used for further
#               operations till the token is valid.

#
#        FILES: ---
#         BUGS: ---
#        NOTES: ---
#       AUTHOR: Kamal Mehta (), 
# ORGANIZATION: Individual Contributer
#      VERSION: 1.0
#      CREATED: 05/29/2019 12:00:56 PM
#     REVISION: ---
#===============================================================================
use strict;
use warnings;
use utf8;

use HTTP::Request::Common qw(GET POST PUT);
use HTTP::Headers;
use LWP::UserAgent;
use JSON;
use Data::Dumper;

sub new{
	my ($class, $args) = @_;
	my $self = bless {
						METHOD=>uc($args->{METHOD}),
						AUTH_URL=>$args->{AUTH_URL},
						DATA=>$args->{DATA}
					}, $class;
}

sub getAuthURL{
	my $self = shift;
	return $self->{AUTH_URL};
}

sub getRequestData{
	my $self = shift;
	return Dumper($self->{DATA});
}

sub requestOAuthToken{
	my $self = shift;
	my $request;

	if(defined $self->{METHOD} && $self->{METHOD}=~/POST/){
		$request = POST($self->{AUTH_URL},$self->{DATA});
	} else {
		$request = GET($self->{AUTH_URL});
	}

	my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 },protocols_allowed => ['https','http']);
	my $response = $ua->request($request);
	
	if($response->is_success){
		return decode_json($response->content);
	} else {
		print("Request Data Error\n");
		print Dumper($response)."\n";
		return Dumper($self->getData());
	}
}

sub setToken{
	my ($self,$token) = @_;
	$self->{ACCESS_TOKEN}=$token->{'access_token'};
	$self->{TOKEN_TYPE}=$token->{'token_type'};
	$self->{REFRESH_TOKEN}=$token->{'refresh_token'};
	$self->{EXPIRES_IN}=$token->{'expires_in'};
}

sub addHeader{
	my ($self,$headers) = @_;
	my %hdrs;
	if($headers){
		%hdrs = %{$headers};
    } else {	
		%hdrs = (
                        "Content-Type"=>"application/json;charset=UTF-8",
                        "Authorization"=>"$self->{TOKEN_TYPE} $self->{ACCESS_TOKEN}"
                     );
	}
	$self->{HEADERS}=HTTP::Headers->new(%hdrs);
}

sub setData{
	my ($self,$data) = @_;
	undef $self->{DATA};
	$self->{DATA}=$data;
}

sub setMethod{
	my ($self,$method) = @_;
	$self->{METHOD}=uc($method);
}

sub getData{
	my ($self,$url) = @_;
	my $request;

	if(defined $self->{METHOD} && $self->{METHOD}=~/POST/){
		$request = POST($url,$self->{DATA});
	} else {
		$request = GET($url);
	}
	my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 1 },protocols_allowed => ['https','http']);
	#print "HEADERS: ".Dumper($self->{HEADERS})."\n";
	$ua->default_headers($self->{HEADERS});
	my $response = $ua->request($request);

	if($response->is_success){
        return decode_json($response->content);
    } else {
        print("Request Data Error\n");
		print Dumper($response)."\n";
        return Dumper($self->getRequestData());
    }
}

1;
