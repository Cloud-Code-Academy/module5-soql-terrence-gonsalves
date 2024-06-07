/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Terrence Gonsalves
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
        List<Lead> allLeads = [select Id, LastName, Company, Phone, Email from Lead];

        return allLeads;
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.     * 
     * Example: yourMethodName('John') should return all contacts with the first name of John.
     * 
     * @param name The name to filter by.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName(String name) {        
        List<Contact> allContacts = [select Id, Name from Contact where FirstName = :name];

        return allContacts;
    }

    /** 
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName() {        
        List<Contact> allContacts = [select Id from Contact where LastName = 'Smith' or LastName = 'Jones'];
        List<Id> ids = new List<Id>();

        for (Contact c : allContacts) {
            ids.add(c.Id);
        }

        return ids;
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpportunityCountByAccount(String accountId) {
        
        List<Opportunity> allOpportunities = [select Id, Name, AccountId, StageName, CloseDate, Amount from Opportunity where AccountId = :accountId and StageName = 'Closed Won'];

        return allOpportunities;
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount() {        
        Integer accountTotal = [select count() from Account];

        return accountTotal;
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksDueNextWeek() { 
        return new Map<Id, Task>([select Id, Subject, ActivityDate from Task where ActivityDate <= NEXT_N_DAYS:7]);
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain(String domainString) {

        // I know this ask was just to check 'example.com' but I wanted to test variable binding with modifiers 
        String likePhrase = '%' + domainString;
        List<Contact> allContactsWithDomain = [select Id, Name, Email from Contact where Email like :likePhrase];

        return allContactsWithDomain;        
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        String likePhrase = '%' + keyword + '%';
        List<Opportunity> allOpportunitiesWithKeyword = [select Id, Name, AccountId, StageName, CloseDate, Amount from Opportunity where Name like :likePhrase];
        
        return allOpportunitiesWithKeyword;
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {

        // built out this method using dynamic SOQL

        // set of Case Origin to be filtered
        Set<String> filteredOrigins = new Set<String>{'Web', 'Email', ''};

        String queryOrigin = 'select Id, CaseNumber, Origin from Case where Origin not in :filteredOrigins';

        List<Case> caseOriginNI = Database.query(queryOrigin);

        return caseOriginNI; // Replace null with the variable you used to store the result
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String keyword) {
        String inKeyword = '%' + keyword + '%';
        String queryLead = 'select Id, Title, Email, Company, LastName, Phone, LeadSource from Lead where LeadSource = :leadSource or Title like :inKeyword';

        List<Lead> leadResults = Database.query(queryLead);

        return leadResults;
    }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> contactsLastName = new List<String>();
        List<Contact> filteredContacts = [select Id, LastName from Contact where AccountId = :accountId];
        
        // loop through each Contact and add the LastName to the list
        for (Contact c : filteredContacts) {
            contactsLastName.add(c.LastName);
        }

        // Return the list of Contact LastNames
        return contactsLastName; // Replace null with the variable you used to store the result
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {

        // Use AggregateQuery to get the total revenue
        AggregateResult aggregatedResult = [select sum(Amount) from Opportunity where StageName = :stage or Amount > 10000];
        Decimal totalAmount = (Decimal) aggregatedResult.get('expr0');

        // Return the total amount
        return totalAmount; // Replace null with the variable you used to store the result
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        return [select Id, Name from Account order by Name limit 10]; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        return [select Amount, CloseDate from Opportunity where Amount > 100000 order by CloseDate limit 5]; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        return [select LastName, Birthdate from Contact where Birthdate >= LAST_N_WEEKS:7 order by Birthdate desc limit 3]; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        return [select Id, CreatedDate from Case where Status = 'Open' order by CreatedDate limit 10 offset 5]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        
        // Create a list to hold the Cases
        Set<Id> caseIds = new Set<Id>();
        List<Case> filteredCases = [select Id from Case where AccountId = :accountId];
        
        // Query the Cases

        // loop through each Case and add the Id to the set
        for (Case c : filteredCases) {
            caseIds.add(c.Id);
        }

        return caseIds; // Replace null with the variable you used to store the result
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        // Query the Accounts
        List<Account> accountIdsNames = [select Id, Name from Account where BillingCountry != :country]; 
        
        // Loop through each Account and add the Id and Name to the map
        for (Account a : accountIdsNames) {
            accountIdsToNames.put(a.Id, a.Name);
        }

        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        Contact contact = [select AccountId from Contact where Id = :contactId];
        
        // just in case nothing is returned for the supplied contact ID lets exit with null (I need to remember to add some safe guards as good practice)
        if (contact == null) {
            return null;
        }

        // just to practice direct value from query with the dot operator
        return [select Name from Account where Id = :contact.AccountId].Name;
    }   

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        Account accountWithOpportunities = [select Id, Name, (select Id, Name from Opportunities) from Account where Id = :accountId];

        return accountWithOpportunities; // Replace null with the variable you used to store the result
    } 

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        List<Contact> contactsByBillingState = new List<Contact>();

        // Query the Account
        Account account = [select Id, BillingState from Account where Id = :accountId];

        // check if the BillingState is null
        if (account.BillingState == null) {
            return contactsByBillingState;
        }

        // Query the Contacts
        contactsByBillingState = [select MailingState from Contact where MailingState = :account.BillingState];

        return contactsByBillingState; // Replace null with the variable you used to store the result
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads
        List<Lead> leads = [select Email from Lead where Id in :leadIds];
        Set<String> domains = new Set<String>();
        List<Account> accountsWithLeadEmail = new List<Account>();

        for (Lead l : leads) {
            domains.add('www.' + l.Email.split('@')[1]);
        }
        
        accountsWithLeadEmail = [select Id, Website from Account where Website in :domains];
        
        // Query the Accounts
        return accountsWithLeadEmail; // Replace null with the variable you used to store the result
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {

        // Query the original Opportunity Line Items
        List<OpportunityLineItem> originalLineItems = [select Id, Quantity, UnitPrice, PricebookEntryId from OpportunityLineItem where OpportunityId = :origOppId];
        
        // Clone and Insert the Opportunity Line Items 
        
        // Create a list of cloned Opportunity Line Items
        List<OpportunityLineItem> oppLineItemsInsert = new List<OpportunityLineItem>();

        // Create a list to hold the new line items

        // Generate a random number between 1 and 3
        Integer randomNum = (Integer) Math.random() * (3 - 1) + 3;

        // Loop through each cloned Opportunity Id
        for (Id id : cloneOppIds) {

            // Loop through each original line item
            for (OpportunityLineItem oppLineItem : originalLineItems) {
                OpportunityLineItem clonedOppLineItem = oppLineItem.clone(false, false, false, false);
                
                // Clone the original line item and add the random number to the quantity
                clonedOppLineItem.OpportunityId = id;
                clonedOppLineItem.Quantity = oppLineItem.Quantity + randomNum;

                oppLineItemsInsert.add(clonedOppLineItem);
            }
        }

        // Insert the new line items
        insert oppLineItemsInsert;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {  
        List<Opportunity> opportunityList = [
            select Name, Account.Name, Owner.Name
            from Opportunity
            where StageName = 'Closed Won' and AccountId != NULL
        ];

        return opportunityList; // Replace null with the variable you used to store the result
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> opportunities = SOQL.getOpportunityDetailsForClosedWon();

        // Create a set of Account Ids from the Opportunities
         Set<Id> accountIds = new Set<Id>();

        for (Opportunity oid : opportunities) {
            accountIds.add(oid.AccountId);
        }

        // Query the Contacts 
        List<Contact> allContacts = [select Id, Name, AccountId from Contact where AccountId in :accountIds];

        Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();

        // Loop through each Contact and add the Account Id and Contact to the map
        for (Contact c : allContacts) {
            accountToContactMap.put(c.AccountId, c);
        }

        
        // Loop through each Opportunity
        for (Opportunity o : opportunities) {
            // Update the Opportunity primary contact from accountToContactMap
            o.Primary_Contact__c = accountToContactMap.get(o.AccountId).Id;
        }

        // Update the Opportunities
        update opportunities;

    }
}