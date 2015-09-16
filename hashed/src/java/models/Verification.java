package models;

import java.util.List;
import org.parse4j.ParseException;
import org.parse4j.ParseObject;
import org.parse4j.ParseQuery;

public class Verification {
    public static String save (String email) throws ParseException {
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Verification");
        query.whereEqualTo("email", email);
        List<ParseObject> verificationRetrieved = query.find();
        ParseObject verification = null;
        if (verificationRetrieved == null  || verificationRetrieved.isEmpty()){
            verification = new ParseObject("Verification");
            verification.put("email", email);
            verification.put("verified", false);
            verification.save();
        } else {
            verification = verificationRetrieved.get(0);
        }
        return verification.getObjectId();
    }
    
    public static String verify (String code) throws ParseException {
        ParseQuery<ParseObject> query = ParseQuery.getQuery("Verification");
        query.whereEqualTo("objectId", code);
        List<ParseObject> verificationRetrieved = query.find();
        if (!(verificationRetrieved == null  || verificationRetrieved.isEmpty())){
            ParseObject verification = verificationRetrieved.get(0);
            String email = verification.getString("email");
            verification.put("verified", true);
            verification.saveInBackground();
            return email;
        }
        return null;
    }
}
