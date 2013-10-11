Check out http://shopify.github.com/dashing for more information.

Relevant Ceilometer API calls are in the jobs/sample.rb file. 
in the jobs/sample.rb file, you must insert your OpenStack token, or change the API calls to accept your username and password.
The OpenStack token can be grabbed by running the keysotone token-get command


1. Open jobs/sample.rb 
2. Insert your openstack keystone token where it says "your token". You can get this token by doing a "keystone token-get".
3. run "dashing start" in the top level directory of the project. 
4. navigate to http://"your-ip":3030 
5. Develop. 
