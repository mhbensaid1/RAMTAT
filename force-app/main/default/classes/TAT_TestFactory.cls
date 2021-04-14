@isTest
public with sharing class TAT_TestFactory {
    // Create user
    public static User createUser (String profileName, Boolean doInsert) {
        User result = new User(
            ProfileId = [
                SELECT  Id
                FROM    Profile
                WHERE   Name = :profileName
                LIMIT 1
            ].Id,
            LastName = 'LastName',
            FirstName='FirstName',
            Email = 'ram@ramtat.com',
            Username = 'ram@ramtat.com' + System.currentTimeMillis(),
            CommunityNickname = 'ram' + System.currentTimeMillis(),
            CompanyName = 'ram',
            Title = 'Volunteer',
            Alias = 'ram',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            isActive = true
        );

        if (doInsert) {
            insert result;
        }
        return result;
    }

    public static List<User> createUsersWithExternalID(String profileName, Integer numberOfUsers, Boolean doInsert) {
     List<User> users = new List<User>();
        for(Integer i=0; i<numberOfUsers;i++){
            User user = new User(
                ProfileId = [
                    SELECT  Id
                    FROM    Profile
                    WHERE   Name = :profileName
                    LIMIT 1
                ].Id,
                LastName = 'LastName',
                FirstName='FirstName',
                Email = 'ram@ramtat.com',
                Username = 'ram@ramtat.com' + System.currentTimeMillis(),
                CommunityNickname = 'ram' + System.currentTimeMillis(),
                CompanyName = 'ram',
                Title = 'Volunteer',
                Alias = 'ram',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                isActive = true,
                Matricule_employe__c = String.valueOf(i)
            );

            users.add(user);
        }

      

        if (doInsert) {
            insert users;
        }
        return users;
    }


    public static Type_Appareil__c createTypeAppareil(String category){
        Type_Appareil__c typeApp = new Type_Appareil__c(
            Categorie_d_appareil__c = category,
            Type__c = 'P',
            Nom_Appareil__c = '738');
        insert typeApp;
        return typeApp;

    }
    // Create Appareils : name => 788, 789
    public static Appareil__c createAppareil(String name, Id typeAppId) {
        Appareil__c result = new Appareil__c(
            Name = name,
            Seats_C__c = 300,
            Type_Appareil__c = typeAppId,
            Seats_Y__c = 200,
            Appareil__c  = '7M8'
        );      
        insert result;
        return result;
    }
    // Create Vols
     public static list<Vol_TAT__c> createVols(Integer nbre,String numero, Integer minute, String escaleDepart,Id appareilId, Boolean doInsert) {
        list<Vol_TAT__c> results = new list<Vol_TAT__c>();        
        for (Integer i = 0; i < nbre; i++) {
            results.add(new Vol_TAT__c(
                Appareil__c = appareilId,
                Date_de_depart_prevue__c = Datetime.now().addMinutes(minute),
                Date_d_arrivee_prevue__c = Datetime.now().addMinutes(minute+180),
                Numero_du_vol__c = Decimal.valueOf(numero+i),
                Escale_arrivee_realisee__c = escaleDepart,              
                Vol_Ram__c = true,
                Compagnie_transporteur__c = 'AT',
                Jour_du_vol__c='2019010'+i,
                Escale_depart_realisee__c='CMN'
            ));
        }       
        if (doInsert) insert results;
        return results;
    }
    
    
    // Create second Vols pour Touchee
    public static list<Vol_TAT__c> createVolsTouchee(Integer nbre,String numero, Integer minute, String escaleDepart,Id appareilId, Boolean doInsert) {
        list<Vol_TAT__c> results = new list<Vol_TAT__c>();        
        for (Integer i = 0; i < nbre; i++) {
            results.add(new Vol_TAT__c(
                Appareil__c = appareilId,
                Date_de_depart_prevue__c = Datetime.now().addMinutes(minute),
                Date_d_arrivee_prevue__c = Datetime.now().addMinutes(minute+180),
                Numero_du_vol__c = Decimal.valueOf(numero+i),
                Escale_arrivee_realisee__c = escaleDepart,              
                Vol_Ram__c = true,
                Compagnie_transporteur__c = 'AT',
                Jour_du_vol__c='2019010'+i,
                Escale_depart_realisee__c='TUN'
            ));
        }       
        if (doInsert) insert results;
        return results;
    }
    // Create tache 
    public static list<Tache__c> createTaches(Integer nbre, Boolean isExceptionnelle, Boolean isAutomatique, Boolean isCritique,Boolean doInsert) {
        list<Tache__c> results = new list<Tache__c>();        
        for(Integer i = 0; i < nbre; i++) {                 
            Tache__c tache = new Tache__c();
            tache.Active__c = true;
            tache.Titre_de_la_tache__c='Contrôle soute '+i;
            tache.Famille_de_tache__c='Catering';
            tache.Phase_de_tache__c='Arrivée';
            tache.Description_de_la_tache__c = 'Test'+i;
            if(isExceptionnelle == true){
                tache.Tache_exceptionnelle__c = true;
            }
            if(isAutomatique == true){
                tache.Tache_automatique__c = true;
            }
            if(isCritique == true){
                tache.Critique__c = true;
            }
            results.add(tache);
        }       
        if (doInsert) insert results;
        return results;
    }
    //Create raisons de retard for a specific task
    public static List<Raison_de_retard__c> createRaisonsRetard(Integer nbre, Id taskId, Boolean doInsert){      
        list<Raison_de_retard__c> results = new list<Raison_de_retard__c>();        
        for (Integer i = 0; i < nbre; i++) {
            results.add(new Raison_de_retard__c(
                Name = 'raison '+i,
                Tache__c = taskId
            ));
        }       
        if (doInsert) insert results;
        return results;
    }
    // Create Role de taches
    public static Role_de_tache__c createRoleTache(Id tacheId, String role, Boolean doInsert) {
        Role_de_tache__c result = new Role_de_tache__c(
                Tache__c = tacheId,
                Role__c = role,
                Peut_demarrer_la_tache__c = true
            );  
        if (doInsert) insert result;
        return result;
    }
    // Create Standard de taches
    public static list<Standard_des_taches__c> createStandardTaches(Integer nbre, Id tacheId, String typeTAT, String typeApp,String bt, Boolean doInsert) {
        list<Standard_des_taches__c> results = new list<Standard_des_taches__c>();        
        for (Integer i = 0; i < nbre; i++) {
            results.add(new Standard_des_taches__c(
                Type_TAT__c = typeTAT,
                Tache__c = tacheId,
                Date_debut_standard__c = -i*10,
                Date_fin_standard__c = -i*5,
                Type_d_appareil__c = typeApp,
                Date_de_reference__c = bt
            ));
        }       
        if (doInsert) insert results;
        return results;
    }
    // Create Dispatch Vol
    public static Dispatch_Vol__c createDispatchVol(Id recordTypeId, Id tatId, Vol_TAT__c vol, User user, String role, Boolean doInsert){
        Dispatch_Vol__c dispatchVol = new Dispatch_Vol__c(RecordTypeId = recordTypeId, 
                                                          TAT__c = tatId, 
                                                          Vol_Arrivee__c = vol.id,
                                                          User__c = user.id,
                                                          Is_Passive__c = false,
                                                          Role__c = role);
        if (doInsert) insert dispatchVol;
        return dispatchVol;
    }
    // Create Dispatch Vol
    public static Dispatch_Vol__c createDispatchVolAD(Id recordTypeId, Id tatId, Vol_TAT__c volA, Vol_TAT__c volD, User user, String role, Boolean doInsert){
        Dispatch_Vol__c dispatchVol = new Dispatch_Vol__c(RecordTypeId = recordTypeId, 
                                                          TAT__c = tatId, 
                                                          Vol_Arrivee__c = volA.id,
                                                          Vol_Depart__c = volD.id,
                                                          User__c = user.id,
                                                          Is_Passive__c = false,
                                                          Role__c = role);
        if (doInsert) insert dispatchVol;
        return dispatchVol;
    }
    // Create Dispatch Vol
    public static Dispatch_Vol__c createPassiveANDManualDispatchVol(Id recordTypeId, Id tatId, Vol_TAT__c vol, User user, String role, Boolean isPassiveANDManuel, Boolean doInsert){
        Dispatch_Vol__c dispatchVol = new Dispatch_Vol__c(RecordTypeId = recordTypeId, 
                                                          TAT__c = tatId, 
                                                          Vol_Arrivee__c = vol.id,
                                                          User__c = user.id,
                                                          Is_Passive__c = isPassiveANDManuel,
                                                          Manuel__c = isPassiveANDManuel,
                                                          Role__c = role);
        if (doInsert) insert dispatchVol;
        return dispatchVol;
    }
    
    // Create Task History
    public static list<Historique_de_tache__c> createHistoriquesTaches(Integer nbre, String status,Id dispachtchVol,Id vol,Id tache,User user, Boolean doInsert) {
        list<Historique_de_tache__c> results = new list<Historique_de_tache__c>();        
        for (Integer i = 0; i < nbre; i++) {
            results.add(new Historique_de_tache__c(
                Vol__c = vol,
                Tache__c=tache,
                Date_debut_standard__c = Datetime.now().addMinutes(i*2),
                Date_fin_standard__c = Datetime.now().addHours(i*2),
                Responsable_Tache_2__c = user.id,
                Dispatch_Vol__c=dispachtchVol,
                Statut__c=status
            ));
        }       
        if (doInsert) insert results;
        return results;
    }    
    /*
    * @desc    this method loads Service Tiles mdt
    * @return  tiles
    */
    public static  List<TAT_AppSetting__mdt> loadAppSettings(String category) {
        List<TAT_AppSetting__mdt> appSettings = [SELECT MasterLabel, TAT_Value__c
            FROM TAT_AppSetting__mdt
            WHERE TAT_Category__c =:category];
        return appSettings;
    }
    
    // Create Ressources
    public static list<Ressource__c> createRessource(Integer nbre,String roleRessource,String nom, Boolean doInsert) {
        list<Ressource__c> results = new list<Ressource__c>();        
        for (Integer i = 0; i < nbre; i++) {
            results.add(new Ressource__c(
                Role_de_la_resource__c = roleRessource,
                Nom_de_la_ressource__c = nom
            ));
        }       
        if (doInsert) insert results;
        return results;
    }
    
     // Create Materiel
    public static list<Materiel__c> createMateriel(Integer nbre,String nom, Boolean doInsert) {
        list<Materiel__c> results = new list<Materiel__c>();        
        for (Integer i = 0; i < nbre; i++) {
            results.add(new Materiel__c(
                Nom_du_materiel__c = nom
            ));
        }       
        if (doInsert) insert results;
        return results;
    }

}