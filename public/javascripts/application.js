// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function getName(){
	val = document.getElementById('twid').value;
alert(val);
	val = $.ajax({
                type: 'GET',
                url: '/getrealname',
                data: 'twitid=' + val,
                async: false,
                success: function(msg){
                        return msg ;
                }
        }).responseText;
        alert(val);
   document.getElementById('twid').value = val;
}

function getTweet(){
	tweet = $.ajax({
				type: 'GET',
				url: '/get_first_n_tweets',
				data: 'count=' + 100 + '&pg=' + 3,
				async: false,
				success: function(msg){
                        return msg ;
                }
        }).responseText;
   document.getElementById('tweetarea').value = tweet;
  }
				
function doSearch(){
	val = document.getElementById('srchid').value;
	alert(val);
	tweet = $.ajax({
				type: 'GET',
				url: '/get_search_results',
				data: 'srchterm=' + val,
				async: false,
				success: function(msg){
                        return msg ;
                }
        }).responseText;
   document.getElementById('srcharea').value = tweet;
  }
  
function authenticateJS(){
	alert('1');
	request_token_response = $.ajax({
			type: 'GET',
			url: '/do_tweets_authcate',
			async: false,
			success: function(msg){
                return msg ;
            }
        }).responseText;
   alert(request_token_response);
  } 
