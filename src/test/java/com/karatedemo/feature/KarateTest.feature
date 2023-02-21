Feature: Verify Persons

  Background:
    Given url 'https://karate-testsuite-mock.free.beeceptor.com'

	@debug
  	Scenario: Get all persons
    Given path '/api/users'
    When method get
    Then status 200    
	Then match response == { data:'#array', support: '##object'}
	Then match response.data[*] contains {id:'#number? _ > 0', email:'#regex .+@reqres.in', first_name:'#string', last_name:'#string', avatar: '#string'}

	@debug
  	Scenario: Get Single Person
    Given path '/api/users/4'
    When method get
    Then status 200
    # use def keyword to the variable
    * def id = response.id
    Then match id == 4
    # contains example
    Then match response contains {"first_name": "Janet"}
    Then match response.first_name ==  'Janet'
    Then match response.last_name !=  'Weavered'


    @debug
    Scenario: Create a New Person
      Given path '/api/createuser'
      And request
      """
      {
    	"name": "CTS",
    	"job": "India"
	  }
      """
      When method POST
      Then status 201
      * def personId = response.id

      Given path 'api/users/'+personId
      When method get
      Then status 200
      
    @debug
    Scenario: Delete an existing Person
      Given path '/api/dropuser'
      And request
      """
      {
    	"id": "11"
	  }
      """
      When method DELETE
      Then status 200
      Then match response.status ==  'User Dropped'
