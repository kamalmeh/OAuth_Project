# OAuth_Project
This project gives a common framework which can be used for any OAuth supporting organization for Authentication purpose.

# OAuth Example

my $OAuthReq=OAuth->new({
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

my $tokenData = $OAuthReq->requestOAuthToken();
$OAuthReq->setToken($tokenData);
$OAuthReq->addHeader({"Content-Type"=>"application/json;charset=UTF-8","Authorization"=>"$tokenData->{token_type} $tokenData->{access_token}"});
$OAuthReq->setMethod("GET");
$OAuthReq->getData($DataURL);


