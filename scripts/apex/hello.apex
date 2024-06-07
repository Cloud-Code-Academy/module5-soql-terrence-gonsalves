// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

     public static void getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<Contact> contactsLastName = [select LastName from Contact where AccountId = :accountId];

        // Query the Contacts
        // Loop through each Contact and add the LastName to the list
        //for () {
        //    
        //}

        // Return the list of Contact LastNames
        System.debug(contactsLastName); // Replace null with the variable you used to store the result
    }

    getContactNamesByAccount('001aj000003ztu4AAA');