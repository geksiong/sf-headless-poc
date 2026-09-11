public with sharing class TopOpportunities {

    public class Request {
        @InvocableVariable(
            label='Result Limit'
            description='Maximum number of top opportunities to return. Defaults to 5 when not specified.'
            required=false
        )
        public Integer limitCount;
    }

    @InvocableMethod(label='Get Top Opportunities' description='Returns the top open opportunities ranked by amount with key details.')
    public static List<TopOpportunitiesResult> getTopOpportunities(List<Request> requests) {
        Integer limitCount = 5;
        if (requests != null && !requests.isEmpty()) {
            Request req = requests[0];
            if (req.limitCount != null && req.limitCount > 0) {
                limitCount = req.limitCount;
            }
        }
        List<TopOpportunity> items = new List<TopOpportunity>();
        List<Opportunity> opportunities = [
            SELECT Name, Account.Name, Description, Amount, Owner.Name,
                   CloseDate, StageName, Probability,
                   (SELECT Contact.Name FROM OpportunityContactRoles WHERE IsPrimary = true LIMIT 1)
            FROM Opportunity
            WHERE IsClosed = false
            ORDER BY Amount DESC NULLS LAST
            LIMIT :limitCount
        ];
        for (Opportunity opp : opportunities) {
            String contactName = opp.OpportunityContactRoles.isEmpty()
                ? ''
                : opp.OpportunityContactRoles[0].Contact.Name;
            items.add(new TopOpportunity(
                opp.Name,
                opp.Account?.Name ?? '',
                contactName,
                opp.Description ?? '',
                opp.Amount ?? 0,
                opp.Owner?.Name ?? '',
                opp.CloseDate?.format() ?? '',
                opp.StageName,
                opp.Probability ?? 0,
                (opp.Amount ?? 0) * (opp.Probability ?? 0) / 100
            ));
        }
        TopOpportunities payload = new TopOpportunities();
        payload.opportunities = items;
        return new List<TopOpportunitiesResult>{ new TopOpportunitiesResult(payload) };
    }

    public class TopOpportunitiesResult {
        @InvocableVariable public TopOpportunities payload;
        public TopOpportunitiesResult(TopOpportunities payload) {
            this.payload = payload;
        }
    }

    @AuraEnabled public List<TopOpportunity> opportunities;

    public class TopOpportunity {
        @AuraEnabled public String name;
        @AuraEnabled public String account;
        @AuraEnabled public String contact;
        @AuraEnabled public String description;
        @AuraEnabled public Decimal amount;
        @AuraEnabled public String owner;
        @AuraEnabled public String closeDate;
        @AuraEnabled public String stage;
        @AuraEnabled public Decimal probability;
        @AuraEnabled public Decimal expectedRevenue;

        public TopOpportunity(String name, String account, String contact, String description, Decimal amount,
                              String owner, String closeDate, String stage, Decimal probability,
                              Decimal expectedRevenue) {
            this.name = name;
            this.account = account;
            this.contact = contact;
            this.description = description;
            this.amount = amount;
            this.owner = owner;
            this.closeDate = closeDate;
            this.stage = stage;
            this.probability = probability;
            this.expectedRevenue = expectedRevenue;
        }
    }
}