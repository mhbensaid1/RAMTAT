public with sharing class Util {

// static variables
    public static Map<String,ID> MAPRTItineraire {get;set;}
    public static Map<String,ID> MAPRTLignedemande {get;set;}
    public static Map<String,ID> MAPRTCotation {get;set;}
    public static Map<String,ID> MAPQueueCotation {get;set;}
    public static Map<String,ID> MAPRTOpportunity {get;set;}
    public static Map<String,ID> MAPRTContrat {get;set;}
    public static Map<String,ID> MAPRTLigneContrat {get;set;}
     public static Map<String,ID> MAPRTMarche {get;set;}
     public static Map<String,ID> MAPRTObjectifSecteur {get;set;}
      public static Map<String,ID> MAPRTResultat {get;set;}
    public static Map<String,Double> conversionRates {get;set;}
     public static Map<String,List<DatedConversionRate>> datedconversionRates {get;set;}
    
     public static  Map<String,Double> getconversionRates(){
        if(conversionRates==null)
        {
            conversionRates=new Map<String,Double>();
            List<CurrencyType> lst = [SELECT IsoCode,ConversionRate 
                                             FROM CurrencyType  ];
        for(CurrencyType cur:lst)
            {
                if(!conversionRates.containskey(cur.IsoCode))conversionRates.put(cur.IsoCode,cur.ConversionRate);
            }
        }
        return conversionRates;
    } 
    
    public static  Map<String,List<DatedConversionRate>> getdatedconversionRates(set<String> isocodes){
      
       
        if(datedconversionRates==null)
        {
             datedconversionRates=new Map<String,List<DatedConversionRate>>();
             List<DatedConversionRate> lst = [SELECT  ConversionRate, IsoCode, StartDate, NextStartDate FROM DatedConversionRate where IsoCode IN :isocodes  ];
             for (DatedConversionRate cur :lst){
                    
                    if(!datedconversionRates.containsKey(cur.IsoCode))  
                        {
                          datedconversionRates.put(cur.IsoCode,new List<DatedConversionRate>());
                        }
                       
                     datedconversionRates.get(cur.IsoCode).add(cur); 
             }
        }
        return datedconversionRates;
    } 
    
    public static  Map<String,ID> getMAPRTOpportunity(){
        if(MAPRTOpportunity==null)
        {
            MAPRTOpportunity=new Map<String,ID>();
            List<RecordType> lst = [Select r.Id ,r.DeveloperName From RecordType r where  r.sObjectType = :'Opportunity'];
        for(RecordType rt:lst)
            {
                if(!MAPRTOpportunity.containskey(rt.DeveloperName))MAPRTOpportunity.put(rt.DeveloperName,rt.Id);
            }
        }
        return MAPRTOpportunity;
    } 
  public static  Map<String,ID> getMAPRTMarche(){
        if(MAPRTMarche==null)
        {
            MAPRTMarche=new Map<String,ID>();
            List<RecordType> lst = [Select r.Id ,r.DeveloperName From RecordType r where  r.sObjectType = :'Marche__c'];
        for(RecordType rt:lst)
            {
                if(!MAPRTMarche.containskey(rt.DeveloperName))MAPRTMarche.put(rt.DeveloperName,rt.Id);
            }
        }
        return MAPRTMarche;
    } 
     public static  Map<String,ID> getMAPRTResultat(){
        if(MAPRTResultat==null)
        {
            MAPRTResultat=new Map<String,ID>();
            List<RecordType> lst = [Select r.Id ,r.DeveloperName From RecordType r where  r.sObjectType = :'Resultat__c'];
        for(RecordType rt:lst)
            {
                if(!MAPRTResultat.containskey(rt.DeveloperName))MAPRTResultat.put(rt.DeveloperName,rt.Id);
            }
        }
        return MAPRTResultat;
    } 
   public static  Map<String,ID> getMAPRTContrat(){
        if(MAPRTContrat==null)
        {
            MAPRTContrat=new Map<String,ID>();
            List<RecordType> lst = [Select r.Id ,r.DeveloperName From RecordType r where  r.sObjectType = :'Contract'];
        for(RecordType rt:lst)
            {
                if(!MAPRTContrat.containskey(rt.DeveloperName))MAPRTContrat.put(rt.DeveloperName,rt.Id);
            }
        }
       
        return MAPRTContrat;
    } 
      public static  Map<String,ID> getMAPRTLigneContrat(){
        if(MAPRTLigneContrat==null)
        {
            MAPRTLigneContrat=new Map<String,ID>();
            List<RecordType> lst = [Select r.Id ,r.DeveloperName From RecordType r where  r.sObjectType = :'Parcours__c'];
        for(RecordType rt:lst)
            {
                if(!MAPRTLigneContrat.containskey(rt.DeveloperName))MAPRTLigneContrat.put(rt.DeveloperName,rt.Id);
            }
        }
         System.debug('######MAPRTLigneContrat'+MAPRTLigneContrat);
        return MAPRTLigneContrat;
    } 
    public static  Map<String,ID> getMAPRTItineraire(){
        if(MAPRTItineraire==null)
        {
            MAPRTItineraire=new Map<String,ID>();
            List<RecordType> lst = [Select r.Id ,r.DeveloperName From RecordType r where  r.sObjectType = :'Itineraire__c'];
        for(RecordType rt:lst)
            {
                if(!MAPRTItineraire.containskey(rt.DeveloperName))MAPRTItineraire.put(rt.DeveloperName,rt.Id);
            }
        }
        return MAPRTItineraire;
    }    
    // Get Cotation lines record Types
    public static  Map<String,ID> getMAPRTlignedemande(){
        if(MAPRTLignedemande==null)
        {
            MAPRTLignedemande=new Map<String,ID>();
            List<RecordType> lst = [Select r.Id ,r.DeveloperName From RecordType r where  r.sObjectType = :'Lignededemande__c'];
        for(RecordType rt:lst)
            {
                if(!MAPRTLignedemande.containskey(rt.DeveloperName))MAPRTLignedemande.put(rt.DeveloperName,rt.Id);
            }
        }
        return MAPRTLignedemande;
    }    
   // Get Cotation recordType 
    public static  Map<String,ID> getMAPRTCotation(){
        if(MAPRTCotation==null)
        {
            MAPRTCotation=new Map<String,ID>();
            List<RecordType> lst = [Select r.Id ,r.DeveloperName From RecordType r where  r.sObjectType = :'DemandeDeCotation__c'];
        for(RecordType rt:lst)
            {
                if(!MAPRTCotation.containskey(rt.DeveloperName))MAPRTCotation.put(rt.DeveloperName,rt.Id);
            }
        }
        return MAPRTCotation;
    }    
   // Get Queues
      public static  Map<String,ID> getMAPQueueCotation(){
        if(MAPQueueCotation==null)
        {
            MAPQueueCotation=new Map<String,ID>();
            List<QueueSobject> lst = [SELECT QueueId, queue.Name,queue.DeveloperName FROM QueueSobject WHERE SobjectType = 'DemandeDeCotation__c'];
           
        for(QueueSobject qu:lst)
            {
                if(!MAPQueueCotation.containskey(qu.queue.DeveloperName))MAPQueueCotation.put(qu.queue.DeveloperName,qu.QueueId);
            }
        }
        return MAPQueueCotation;
    }    
    
    public static Decimal convertCurrencyWithApexCode(String oCurrency, String nCurrency, Decimal amount){
        
      
        Double conversionRate;
        if (amount == null)
            amount =0;
        if (nCurrency !='MAD')
         conversionRate = getconversionRates().get(nCurrency);
        else
         conversionRate = getconversionRates().get(oCurrency);
       
        if (nCurrency !='MAD')
        if (nCurrency !=oCurrency){
            if (nCurrency == 'MAD'){ 
                amount = amount / conversionRate;
            }
            else{
                amount = amount * conversionRate;
            }
        }
        
        
        
        
        return amount;
    }
    
    public static Decimal datedconvertCurrencyWithApexCode(Set<String> currencies,String oCurrency, String nCurrency,Date closeDate, Decimal amount){
        
      
        Double conversionRate;
        if (amount == null)
            amount =0;
            
      system.debug('DHJ mapmontant'+    getdatedconversionRates(currencies));
      
        if (nCurrency !='MAD'){
            if (getdatedconversionRates(currencies)!= null )
              if (getdatedconversionRates(currencies).get(nCurrency) !=null)
            for (DatedConversionRate con : getdatedconversionRates(currencies).get(nCurrency)) {
                if ( closeDate > con.StartDate && closeDate < con.NextStartDate)
                   conversionRate =  con.ConversionRate;
            }
            
            system.debug('DHJ nonMAD conversionrate '+conversionRate);
        
        }
        else{
            if (getdatedconversionRates(currencies)!= null )
              if (getdatedconversionRates(currencies).get(oCurrency)!=null)
         for (DatedConversionRate con : getdatedconversionRates(currencies).get(oCurrency)) {
                if ( closeDate > con.StartDate && closeDate < con.NextStartDate)
                   conversionRate =  con.ConversionRate;
            }
            system.debug('DHJ MAD conversionrate '+conversionRate);
         
        }
       
        
       
        if (nCurrency !=oCurrency){
            if (nCurrency == 'MAD'){ 
                amount = amount / conversionRate;
                 system.debug('DHJ MAD conversionrate '+conversionRate+ 'and amount '+amount);
            }
            else{
                amount = amount * conversionRate;
                system.debug('DHJ MAD conversionrate '+conversionRate+ 'and amount '+amount);
            }
        }
        
        
     
        
        
        return amount;
    }
    
    
    
    public static  Map<String,ID> getMAPRTObjectifSecteur(){
        if(MAPRTObjectifSecteur==null)
        {
            MAPRTObjectifSecteur=new Map<String,ID>();
            List<RecordType> lst = [Select r.Id ,r.DeveloperName From RecordType r where  r.sObjectType = :'ObjectifSecteur__c'];
        for(RecordType rt:lst)
            {
                if(!MAPRTObjectifSecteur.containskey(rt.DeveloperName))MAPRTObjectifSecteur.put(rt.DeveloperName,rt.Id);
            }
        }
        return MAPRTObjectifSecteur;
    }
    
    
    }