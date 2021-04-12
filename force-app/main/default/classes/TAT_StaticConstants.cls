/**
* @author         Salesforce TAT Team
* @date           Dec 27, 2018
* @description    Class for static constants used during the project.
* @history        
*/

public class TAT_StaticConstants {
    
    // Record Types
    public static final String DISPATCH_VOL_RECORD_TYPE_TATMEMBER = 'TAT_member';
    public static final String DISPATCH_VOL_RECORD_TYPE_CREWMEMBER = 'Crew_Member';
    public static final String DISPATCH_VOL_RECORD_TYPE_RESSOURCESUPERVISEUR = 'Ressource_Superviseur';
    public static final String DISPATCH_VOL_RECORD_TYPE_MATERIEL = 'Materiel';
    
    //Ressource
    public static final String RESSOURCE_RECORD_TYPE_RESSOURCESUPERVISEUR = 'Ressource_Superviseur';
    public static final String RESSOURCE_RECORD_TYPE_MCC = 'Ressource_MCC';
    public static final String RESSOURCE_RECORD_TYPE_CATERING = 'Ressource_Catering';
    
    //Materiel
    public static final String MATERIEL_VOL_RECORD_TYPE_SUPERVISEUR = 'Materiel_Superviseur';
    public static final String MATERIEL_VOL_RECORD_TYPE_CATERING = 'Materiel_catering';
    
    /* Start of picklist values */
    
    // Type TAT Global picklist
    public static final String TYPE_TAT_DEPART = System.Label.TAT_Type_TAT_Depart;
    public static final String TYPE_TAT_ARRIVEE = System.Label.TAT_TYPE_TAT_ARRIVEE;
    public static final String TYPE_TAT_ARRIVEEDEPART = System.Label.TAT_TYPE_TAT_ARRIVEEDEPART;
    public static final String STATUS_TAT_ARCHIVE = System.Label.Status_TAT_Archive;
    
    // Status TAT
    public static final String STATUS_BEFORE_START = 'Avant début';
    public static final String STATUS_IN_PROGRESS = 'En Cours';
    public static final String STATUS_AFTER_END = 'Après fin';
    
    // Historique_de_tache__c Object : picklist Statut__c
    public static final String HISTORIQUE_TACHE_STATUS_TERMINEE = System.Label.Historique_Tache_Status_Terminee;
    public static final String HISTORIQUE_TACHE_STATUS_NON_DEMARER = System.Label.Historique_Tache_Status_Non_demarree;  
    public static final String HISTORIQUE_TACHE_STATUS_EN_COURS = System.Label.Historique_Tache_Status_En_Cours;
    public static final String HISTORIQUE_TACHE_STATUS_INTERROMPUE =  System.Label.Historique_Tache_Status_Interrompue;
    
    // Tache__c: picklist Tache specifique
    public static final String  TACHE_SPECIFIQUE_FUELING= System.Label.Picklist_Tache_specifique_Fueling;  
    public static final String  TACHE_SPECIFIQUE_QUANTIE_RESTANTE_EAU_POTABLE= System.Label.Picklist_Tache_specifique_Quantite_restante_eau_potable;  
    public static final String  TACHE_SPECIFIQUE_QUANTITE_EAU_POTABLE_BORD= System.Label.Picklist_Tache_specifique_Quantite_eau_potable_bord;  
    public static final String  TACHE_SPECIFIQUE_ORDONNANCEMENT_BAGGAGE= System.Label.Picklist_Tache_specifique_Ordonnancement_bagages;  
    
    // Log__c
    public static final String LOG_TYPE_ERROR = System.Label.Picklist_Log_Type_Error;
    public static final String LOG_CATEGORY_PARSING = System.Label.Picklist_Log_Category_Parsing;
    public static final String LOG_REMOTE_SYSTEM_NETLINE = System.Label.Picklist_Log_Remote_System_Netline;
    
    /* End of picklist values */
    
    // Status Color css class
    public static final String HISTORIQUE_TACHE_STATUS_END = 'green';
    public static final String HISTORIQUE_TACHE_STATUS_NOT_STARTED = 'grey';
    public static final String HISTORIQUE_TACHE_STATUS_IN_PROGRESS = 'blue';
    
    // Progress Bar Color
    public static final String PROGESS_BAR_DELATED_ALL = 'redAlert';
    public static final String PROGESS_BAR_ON_TIME = 'green';
    public static final String PROGESS_BAR_DELATED_TASK = 'orange';
    
    // Date Format
    public static final String DATE_FORMAT = 'yyyy-MM-dd HH:mm';
    public static final String HOUR_FORMAT = 'HH:mm';
    
    // Monitoring Page : Filter Section:
    public static final String FILTER_ALL = System.Label.All;
    public static final String FILTER_TYPETAT_TOUCHEE = System.Label.Touchee; 
    public static final String AFFECTATION_ECHOUEE = System.Label.Affectation_echouee;
    public static final String TAT_DEJA_AFFECTE_A_AUTRE_USER = System.Label.Ce_TAT_est_deja_affect_un_autre_utilisateur;
    public static final String HANDOVER_ECHOUEE = System.Label.Handover_echoue;
    public static final String FILTER_TYPETAT_DEPART_SEUL = System.Label.Departs_seuls;
    public static final String FILTER_TYPETAT_ARRIVEE_SEUL = System.Label.Arrivees_seules;
    public static final String FILTER_TYPEVOL_RAM = System.Label.RAM;
    public static final String FILTER_TYPEVOL_NO_RAM = System.Label.NO_RAM;
    
    public static final String FILTER_ALL_DEFAULT = System.Label.All;
    public static final String FILTER_AVEC_ALERTES = System.Label.Avec_Alertes;
    public static final String FILTER_MES_ALERTES = System.Label.Mes_Alertes;
    public static final String FILTER_SANS_ALERTES = System.Label.Sans_alertes;
    
    public static final String FILTER_TAT_TOUS_LES_TAT_EN_COURS = System.Label.Tous_les_TATs_en_cours;
    public static final String FILTER_TAT_PROCHAINS_12_HEURES = System.Label.TATs_des_prochaines_12_heures;
    public static final String FILTER_TAT_PRECEDENT_12_HEURES = System.Label.TATs_des_precedentes_12_heures;
    public static final String FILTER_TAT_PROCHAINS_3_HEURES = System.Label.TATs_des_prochaines_3_heures;
    public static final String FILTER_TAT_PROCHAINS_6_HEURES = System.Label.TATs_des_prochaines_6_heures;
    public static final String MESSAGE_RAISON_RETARD = System.Label.Veuillez_remplir_la_raison_de_retard;
    
    // Netline
    public static final String NETLINE_MODIFICATION = 'MODIFICATION';
    public static final String NETLINE_CTOT = 'CTOT';
    public static final String NETLINE_ACH = 'ACH';
    public static final String NETLINE_MVT = 'MVT';
    public static final String NETLINE_ASM = 'ASM';
    public static final String NETLINE_COR = 'COR';
    public static final String NETLINE_NEW = 'NEW';
    public static final String NETLINE_RPL = 'RPL';
    public static final String NETLINE_CNL = 'CNL';
    
    // Custom settings
    public static final String CATEGORY_ROLE_FROM_PROFILE = System.Label.Role_From_Profile;
    public static final String CATEGORY_TASK_FAMILLE_FROM_PROFILE = System.Label.Task_Famille_From_Profile;
    public static final String CATEGORY_ROLE_WITH_LIBERER_RIGHT = 'Roles With Liberer & Handover Right';
    public static final String CATEGORY_DEFAULT_FILTER_FROM_ROLE = 'Default Filter From Role';
    public static final String CATEGORY_DISPATCH_RT_FROM_ROLE = 'Dispatch Record Type From Role';
    public static final String CATEGORY_ALTEA_SETTINGS = 'Altea Settings';
    public static final String CATEGORY_INTERFACES_SETTINGS = 'TAT Interfaces Settings';
    public static final String CATEGORY_ROCADE_SETTINGS = 'Rocade Settings';
    public static final String CATEGORY_BRS_SETTINGS = 'BRS Settings';
    public static final String CATEGORY_BAGAGE = 'Bagage';
    public static final String CATEGORY_ALTEA_All_DATA_SETTINGS = 'Altea All Data Settings';
    public static final String CATEGORY_ALTEA_SPECIFIC_DATA_SETTINGS = 'Altea Specific Data Settings';
    public static final String MANAGER = System.Label.Manager;
    
    // Profiles
    public static final String PROFILE_PC_ESCALE = System.Label.Profile_PC_Escale;
    public static final String PROFILE_SUPERVISEUR = System.Label.Profile_Superviseur;
    public static final String PROFILE_INTERFACE = 'RAM - Interface';
    public static final String PROFILE_MCC = 'RAM TAT - MCC';
    
    public static final String DISPATCH_ROLE_MCC = 'MCC';
    
    // Class Names
    public static final String CLASS_TAT_NETLINE_EMAIL_HANDLER = 'TAT_NetlineEmailHandler';
    public static final String CLASS_TAT_NETLINE_CTOT_EMAIL_HANDLER = 'TAT_NetlineCTOTEmailHandler';
    
    // Method Names   
    public static final String METHOD_HANDLE_INBOUND_EMAIL = 'handleInboundEmail';
    
    //Public group 
    public static final String PUBLIC_GROUP_PASSAGER_VISIBILITY = 'TAT Visibilité Passagers';
        
    //Page Ressource 
    public static final List<String>  LIST_DEFAULT_RESSOURCE = new List<String>{'Agent salle','Agent d\'embarquement','Chef d\'équipe','Cariste','Chauffeur Pushback','Nombre de bagagistes','Nombre agents de nettoyage'};
    public static final List<String>  LIST_DEFAULT_MATERIAL = new List<String>{'GPU','TAPIS A BAGAGE','ESCABEAU','TRACTEUR','PUSHBACK'};
}