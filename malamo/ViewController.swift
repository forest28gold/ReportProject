//
//  ViewController.swift
//  malamo
//
//  Created by AppsCreationTech on 12/12/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var ethnicArray = ["Acadian", "Afghan", "Afrikaner", "Akan", "Albanian", "Albertan", "Algerian", "German", "Alsatian", "American", "Native American / Indigenous", "Amhara", "English (from England)", "Angolan", "Antiguan", "Arab", "Argentinian", "Armenian", "Ashanti", "Assyrian", "Australian", "Austrian", "Azerbaijani", "Bahamian", "Bangladeshi", "Barbadian (Bajan)", "Basque", "Belgian", "Belizean", "Bengali", "Beninese", "Berber", "Bermudian", "Belarusian", "Burmese", "Bolivian", "Bosniak", "Brazilian", "Breton", "British", "British Columbian", "Bulgarian", "Burkinabe", "Burundian", "Cambodian / Khmer", "Cameroonian", "Canadian", "Caribbean / Carib", "Chilean", "Chinese", "Sinhalese", "Colombian", "Congolese", "Coptic", "Korean", "Cornish", "Costa Rican", "Croatian", "Cuban", "Cypriot", "Danish", "Dinka", "Dominican", "Scottish", "Egyptian", "Ecuadorean", "Eritrean", "Spanish", "Estonian", "Ethiopian", "Fijian", "Finnish", "Flemish", "French (from France)", "Frisian", "Gabonese", "Welsh", "Gambian", "Georgian", "Ghanaian", "Greek", "Grenadian", "Guatemalan", "Guinean", "Gujarati", "Guianan / French Guianan", "Haitian", "Hawaiian", "Hispanic", "Hmong / Mong / Miao", "Hollander", "Honduran", "Hungarian", "Igbo", "Indonesian", "Channel Islander", "Inuit", "Iraqi", "Iranian", "Irish", "Icelandic", "Israeli", "Italian", "Ivorian", "Japanese", "Jordanian", "Jewish", "Kazakh", "Kenyan", "Khmer / Cambodian", "Kosovar", "Kuwaiti", "Kurdish", "Labradorian", "Laotian", "Latvian", "Lebanese", "Liberian", "Libyan", "Lithuanian", "Luxembourgish", "Macedonian", "Malaysian", "Madagascan", "Malian", "Maltese", "Manitoban", "Manx", "Maori", "Moroccan", "Martinican", "Moorish", "Mauritian", "Mayan", "Métis", "Mexican", "Moldavian", "Mongolian", "Montenegrin", "Montserratian", "Dutch", "New Brunswicker", "Nova Scotian", "New Zealander", "Nepalese", "Nevisian", "Nicaraguan", "Nigerian", "Norwegian", "Nunavummiut ", "Ontarian", "Goan", "Kashmiri", "Oromo", "Ugandan", "Uyghur", "Uzbek", "Pashtun / Pathan", "Pakistani", "Palestinian", "Panamanian", "Paraguayan", "Punjabi", "Peruvian", "Fula ", "Filipino", "Polish", "Polynesian", "Puerto Rican", "Portuguese", "First Nations", "Prince Edward Islander", "Quebecer / Québécois", "Rom / Gypsy", "Romanian", "Russian", "Rwandan", "St. Lucian", "Vincentian", "Salvadorian", "Samoan", "Saudi Arabian", "Saskatchewanian", "Senegalese", "Serbian", "Seychellois", "Sicilian", "Sierra Leonean", "Singaporean", "Slovak", "Slovenian", "Somali", "Sudanese", "Sri-Lankan", "South African", "Swede", "Swiss", "Syrian", "Tajik", "Taiwanese", "Tamil", "Tanzanian", "Tatar", "Chadian", "Czech", "Tigrayan / Tigrinya ", "People of the North / Nunatsiarnuit", "Newfoundlander", "Thai", "Tibetan", "Tigrayan / Tigrinya ", "Togolese", "Trinidadian / Trinitéen / Tobagonian ", "Tunisian", "Turkish", "Ukrainian", "Uruguayan", "Venezuelan", "Vietnamese", "Vincentian", "Yemeni", "Yoruba", "Yukoner", "Zambian", "Zimbabwean", "Zulu", "Other"]
    
    var ethnicfrArray = ["Acadien", "Afghan", "Afrikaner", "Akan", "Albanais", "Albertain", "Algérien", "Allemand", "Alsacien", "Américain", "Amérindien / Autochtone", "Amhara", "Anglais (d’Angleterre)", "Angolais", "Antiguais", "Arabe", "Argentin", "Arménien", "Ashanti", "Assyrien", "Australien", "Autrichien", "Azerbaïdjanais", "Bahamien", "Bangladeshi", "Barbadien", "Basque", "Belge", "Bélizien", "Bengali", "Béninois", "Berbère", "Bermudien", "Biélorusse", "Birman", "Bolivien", "Bosniaque", "Brésilien", "Breton", "Britannique", "Britanno-Colombien", "Bulgare", "Burkinabè", "Burundais", "Cambodgien / Khmer", "Camerounais", "Canadien", "Caraïbe / Indien caraïbe", "Chilien", "Chinois", "Cingalais", "Colombien", "Congolais", "Copte", "Coréen", "Cornique", "Costaricain", "Croate", "Cubain", "Cypriote", "Danois", "Dinka", "Dominicain", "Écossais", "Égyptien", "Équatorien", "Érythréen", "Espagnol", "Estonien", "Éthiopien", "Fidjien", "Finlandais", "Flamand", "Français (de France)", "Frison", "Gabonais", "Gallois", "Gambien", "Géorgien", "Ghanéen", "Grec", "Grenadien", "Guatémaltèque", "Guinéen", "Gujarati", "Guyanais", "Haïtien", "Hawaïen", "Hispanique", "Hmong / Mong / Miao", "Hollandais", "Hondurien", "Hongrois", "Ibo", "Indonésien", "Insulaire anglo-normand", "Inuit", "Irakien", "Iranien", "Irlandais", "Islandais", "Israélien", "Italien", "Ivoirien", "Japonais", "Jordanien", "Juif", "Kazakh", "Kényan", "Khmer / Cambodgien", "Kosovar", "Koweïtien", "Kurde", "Labradorien", "Laotien", "Letton", "Libanais", "Libérien", "Libyen", "Lituanien", "Luxembourgeois", "Macédonien", "Malaisien", "Malgache", "Malien", "Maltais", "Manitobain", "Mannois", "Maori", "Marocain", "Martiniquais", "Maure", "Mauricien", "Maya", "Métis", "Mexicain", "Moldove", "Mongol", "Monténégrin", "Montserratien", "Néerlandais", "Néo-Brunswickois", "Néo-Écossais", "Néo-Zélandais", "Népalais", "Névicien", "Nicaraguayen", "Nigérian", "Norvégien", "Nunavummiut", "Ontarien", "Originaire de Goa", "Originaire du Cachemire", "Oromo", "Ougandais", "Ouïghour", "Ouzbek", "Pachtoune / Pathan", "Pakistanais", "Palestinien", "Panaméen", "Paraguayen", "Pendjabi", "Péruvien", "Peul", "Philippin", "Polonais", "Polynésien", "Portoricain", "Portugais", "Premières Nations", "Prince-Édouardien", "Québécois", "Rom / Tsigane", "Roumain", "Russe", "Rwandais", "Saint-Lucien", "Saint-Vincentais-et-Grenadin", "Salvadorien", "Samoan", "Saoudien", "Saskatchewanais", "Sénégalais", "Serbe", "Seychellois", "Sicilien", "Sierra-Léonais", "Singapourien", "Slovaque", "Slovène", "Somalien", "Soudanais", "Sri-Lankais", "Sud-Africain", "Suédois", "Suisse", "Syrien", "Tadjik", "Taïwanais", "Tamoul", "Tanzanien", "Tatar", "Tchadien", "Tchèque", "Tegréen / Tigréen", "Ténois", "Terre-Neuvien", "Thaïlandais", "Tibétain", "Tigréen / Tegréen", "Togolais", "Trinidadien / Trinitéen / Tobagonien", "Tunisien", "Turc", "Ukrainien", "Uruguayen", "Vénézuélien", "Vietnamien", "Vincentais", "Yéménite", "Yoruba", "Yukonnais", "Zambien", "Zimbabwéen", "Zoulou", "Autre"]
    
    
    var languageArray = ["French", "English", "Abenaki", "Afrikaans", "Akan (Kwa)", "Albanian", "Algonquian(language)", "Algonquin", "German", "Amharic", "Arabic", "Armenian", "Athapascan (language)", "Atikamekw", "Azerbaijani", "Bambara / Bamanakan / Bamanankan", "Bengali", "Berber (Kabyle)", "Bikol (language)", "Belarusian", "Burmese", "Biscayan", "Bosnian", "Bulgarian", "Cantonese", "Castor / Beaver / Dane-zaa Záágé", "Catalan", "Teochew (Chaozhou)", "Chiac", "Chilcotin", "Chinese", "Mandarin Chinese", "Korean", "Creole", "Cree (Language)", "Croatian", "Dakota", "Danish", "Edo", "Spanish", "Estonian", "Ewe", "Fijian", "Finnish", "Flemish", "Friesian", "Ga", "Gaelic", "Welsh", "Ganda", "Georgian", "Gitxsan", "Greek", "Gujarati", "Haida", "Haisla", "Hakka", "Halkomelem", "Hebrew", "Hindi", "Hungarian", "Igbo", "Ilocano", "Innu / Innu-aimun / Montagnais / Naskapi", "Inuinnaqtun", "Inuktitut (Inuit language)", "Inuvialuktun / Inuktun", "Icelandic", "Italian", "Japanese", "Kannada", "Kaska", "Khmer (Cambodian)", "Konkani", "Kurdish", "Kutenai", "Kwakiutl (Kwak'wala)", "Sign languages", "Lao", "Latvian", "Lillooet", "Lingala", "Lithuanian", "Macedonian", "Malay", "Malayalam", "Malecite", "Malagasy", "Maltese", "Mandarin", "Marathi", "Micmac", "Michif", "Mohawk", "Mongolian", "Montagnais (Innu) ", "Maskekon (Swampy Cree)", "Naskapi", "Dutch", "Nepalese", "Nisga'a", "Nootka (Nuu-chah-nulth)", "Norwegian", "Ojibwe", "Oji-cree", "Okanagan", "Oneida", "Oromo", "Urdu", "Pashto / Pushto / Pushtu", "Pampangan", "Pangasinan", "Punjabi", "Persian (Farsi)", "Polish", "Carrier", "Portuguese", "Romanian", "Rundi (Kirundi)", "Russian", "Rwanda (Kinyarwanda)", "Salish (languages)", "Sarsi", "Serbian", "Serbo-Croatian", "Shanghainese", "Shona", "Shuswap (Secwepemctsin)", "Sindhi", "Sinhalese", "Slovak", "Slovene", "Somali", "Stoney", "Swedish", "Swahili", "Tagalog (Filipino)", "Taiwanese", "Tamil", "Czech", "Telugu", "Thai", "Thompson (Nlaka’pamux)", "Tibetan", "Tigrinya", "Tlicho", "Tlingit", "Tsimshian : Tsimshian languages", "Turkish", "Ukrainian", "Vietnamese", "Wendat", "Wet’suwet’en", "Wolof", "Yiddish", "Other language"]
    
    
    var languagefrArray = ["Français", "Anglais", "Abénaqui", "Afrikaans", "Akan (kwa)", "Albanais", "Algonquienne (langue)", "Algonquin", "Allemand", "Amharique", "Arabe", "Arménien", "Athapascane (langue)", "Atikamekw", "Azerbaïdjanais", "Bambara / Bamanakan / Bamanankan", "Bengali", "Berbère (kabyle)", "Bicol (langue)", "Biélorusse", "Birman", "Biscayen", "Bosniaque", "Bulgare", "Cantonais", "Castor / Beaver / Dane-zaa Záágéʔ", "Catalan", "Chaochow (teochow)", "Chiac", "Chilcotin", "Chinois", "Chinois mandarin", "Coréen", "Créole", "Crie (Langue)", "Croate", "Dakota", "Danois", "Édo", "Espagnol", "Estonien", "Ewe", "Fidjien", "Finnois", "Flamand", "Frison", "Ga", "Gaélique", "Gallois", "Ganda", "Géorgien", "Gitksan", "Grec", "Gujarati", "Haïda", "Haisla", "Hakka", "Halkomelem", "Hébreu", "Hindi", "Hongrois", "Igbo", "Ilocano", "Innu / Innu-aimun / Montagnais / Naskapi", "Inuinnaqtun", "Inuktitut (langue inuite)", "Inuvialuktun / Inuktun", "Islandais", "Italien", "Japonais", "Kannada", "Kaska", "Khmer (cambodgien)", "Konkani", "Kurde", "Kutenai", "Kwakiutl (kwak'wala)", "Langue des signes", "Lao", "Letton", "Lillooet", "Lingala", "Lituanien", "Macédonien", "Malais", "Malayalam", "Malécite", "Malgache", "Maltais", "Mandarin", "Marathi", "Micmac", "Mitchif", "Mohawk", "Mongol", "Montagnais (Montagnais-naskapi)", "Moskégon", "Naskapi", "Néerlandais", "Népalais", "Nisga'a", "Nootka (nuu-chah-nulth)", "Norvégien", "Ojibwé", "Oji-cri", "Okanagan", "Oneida", "Oromo", "Ourdou", "Pachto / Pashto / Pachtou / Pachtoune", "Pampangan", "Pangasinan", "Pendjabi", "Persan (farsi)", "Polonais", "Porteur", "Portugais", "Roumain", "Rundi (kirundi)", "Russe", "Rwanda (kinyarwanda)", "Salish (langues)", "Sarsi", "Serbe", "Serbo-croate", "Shanghaïen", "Shona", "Shuswap (secwepemctsin)", "Sindhi", "Singhalais", "Slovaque", "Slovène", "Somali", "Stoney", "Suédois", "Swahili", "Tagalog (pilipino)", "Taïwanais", "Tamoul", "Tchèque", "Télougou", "Thaï", "Thompson (ntlakapamux)", "Tibétain", "Tigrina", "Tlicho", "Tlingit", "Tsimshian : langues tsimshianiques", "Turc", "Ukrainien", "Vietnamien", "Wendat", "Wet’suwet’en", "Wolof", "Yiddish", "Autre langue"]

    var religionArray = ["Agnosticism", "Atheism", "Bahaism", "Buddhism", "Caodaism", "Catholicism", "Islam", "Hinduism", "Jainism", "Judaism", "Christian Orthodox", "Greek Orthodox", "Paganism", "Pentecostalism", "Presbyterianism", "Protestantism", "African Religion", "Traditional Chinese religion", "Shintoism", "Sikhism", "Native Spirituality", "Tenrikyo", "Zoroastrism", "Other religion", "No religious affiliation"]
    
    var religionfrArray = ["Agnosticisme", "Athéisme", "Bahaïsme", "Bouddhisme", "Caodaïsme", "Catholicisme", "Islam", "Hindouisme", "Jaïnisme", "Judaïsme", "Orthodoxe chrétienne", "Orthodoxe grecque", "Paganisme", "Pentecôtiste", "Presbytérienne", "Protestantisme", "Religion africaine", "Religion traditionnelle chinoise", "Shintoïsme", "Sikhisme", "Spiritualité autochtone", "Tenrikyō", "Zoroastrisme", "Autre religion", "Aucune appartenance religieuse"]
    
    /////////////////
    
    var relationArray = ["Member of the family (father, mother, brother, sister…)", "Friend", "Knowledge (including knowledge Facebook or on others social media)", "Colleague work or study", "Higher than work or school / university", "Spouse", "Member of neighborhood", "Unknown", "No answer"]
    
    var relationfrArray = ["Membre de la famille (père, mère, frère, soeur…)", "Ami", "Connaissance (incluant les connaissances Facebook ou sur les autres médias sociaux)", "Collègue de travail ou d’étude", "Supérieur au travail ou à l’école / université", "Conjoint ", "Membre du voisinage", "Inconnu", "Pas de réponse"]
    
    //////////////
    
    var transportArray = ["Bus or Coach", "Airplane or other Air Transportation", "Metro", "Taxi", "Train", "Tramway", "Ferry or Other Sea Transportation"]
    var internetArray = ["Website", "Blog", "Website \"Comments\" section", "Facebook", "Twitter", "Snapchat", "Instagram", "YouTube", "LinkedIn", "Other"]
    
    var transportfrArray = ["Autobus ou autocar", "Avion ou autre transport aérien", "Métro", "Taxi", "Train", "Tramway", "Traversier ou autre transport maritime"]
    var internetfrArray = ["Site Internet", "Blogue", "Section \"Commentaires\" de sites Web", "Facebook", "Twitter", "Snapchat", "Instagram", "YouTube", "LinkedIn", "Autre"]
    
    ////////////
    
    var learnArray = ["Why prevent hate crimes and incidents?", "Crimes vs. hate incidents: what differnets?", "And hate speech?", "What the law says",
                      "Some figures in Quebec and Canada", "Prevention of hate crime and hate incidents in Quebec", "Preventing hate crimes and incidents in Canada",
                      "Initiatives abroad", "Resources and scientific publications"]
    
    var learnfrArray = ["Pourquoi prévenir les crimes et les incidents haineux?", "Crimes vs. incidents haineux: quelles differences?", "Et le discours haineux dans tout ca?", "Ce que dit la loi?", "Quelques chiffres au Québec et au Canada", "Prévention des crimes et des incidents haineux au Québec", "Prévention des crimes et des incidents haineux au Canada", "Des initiatives à l’étranger", "Ressources et publications scientifiques"]
    
    //////////////
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        initCategoryData()
//        onSaveLanguageData()
//        onSaveEthnicData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func initCategoryData() {
//        var titleArray = ["Abusive Act", "Distribution of offensive or hate material", "Discrimination", "Menace", "Harassment", "Degradation against property / buildings", "Physical violence", "Other"]
//        var infoArray = ["An offensive act, (verbal and non-verbal), involves an intention to hurt others and to be malicious against them by using terms, expressions or mimicry that attack their personal characteristics, such as: their race, national or ethnic origin, language, color, religion, sex, age, mental or physical disability, sexual orientation (including gender identity or expression), social condition and other identifiable factors.",
//                         "Offending or hateful material refers to any written communication or any image (poster, pamphlet, message, logo, symbol, graffiti) that aims to insult an identifiable group or to promote hatred against this group. Offending or hateful material can be disseminated in multiple formats in the real world or through the internet and social media.",
//                         "Discrimination is the act of compromise the right of a person to exercise his rights and freedoms as recognized by the Charter of Human Rights and Freedoms. It is therefore the negative treatment of this person because of his or her belonging to an identifiable group.",
//                         "A threat is a collection of intimidating words or actions that, taken in their context, express a real desire to resort to any violence against a person, his or her family or property in the short or medium term. All intimidating words, actions or actions can be repeated in different situations, which accentuates the importance and seriousness of the threat; a threat may be verbal, physical gesture, written or electronic.",
//                         "Harassment is a repetitive conduct that manifests itself in offensive, contemptuous, hostile, or unwanted words or behavior towards an identifiable individual or group, and that undermines the dignity of the person. these or their psychological or physical health.",
//                         "The degradation of property or buildings is a misdeed recognized by Canadian law. This mischief is the destruction or willful damage to property or property (eg, car, book, house, private or public building, place of worship, store, school, etc.).",
//                         "Physical violence is expressed through the voluntary use of force to perform actions against the will of the person (hustle, hit, cause injury). This type of violence affects the other in physical integrity and can also leave long-term psychological consequences, and even in the most serious cases lead to death. Encouragement of physical violence by an identifiable group or specific individuals because of their characteristics is also included in this category, which goes beyond the mere threat.",
//                         "Select this category if the incident or hate crime you want to report does not seem to fit into one of the proposed categories."]
//        var exampleArray = ["• Insulting the owner of a business reason for his religion;\n• Make offensive gestures to an individual in making fun of his physical appearance.",
//                            "• In a shopping mall, deposit anti-Muslim leaflets on car windshields;\n• On Facebook, share an image that incites discrimination and intolerance against indigenous people;\n• Distribute clothing with the logo of a hate group.",
//                            "• Refuse to house a gay couple in a hotel;\n• On a poster announcing an apartment for rent, specify \"No immigrants\";\n• Do not hire a person because that she is transgender.",
//                            "• Threatening a shopkeeper by saying that his store will be set on fire or understudied because of his Jewish origins;\n• Publish threatening comments in the comments section of a website openly the members of the Asian community.",
//                            "• Regularly follow a woman on the street by making sexist and shocking remarks;\n• Harass a homeless person in order to prevent him from attending a place or being present in a public space.",
//                            "• Pour pork blood on the door of a mosque;\n• Draw provocative graffiti (Ku Klux Klan, swastika, skull, etc.) on the walls of a Jewish school;\n• Break the windows of all cars in the parking lot of a gay bar, with the intention of intimidating clients because of their sexual orientation.",
//                            "• Violently push a person down the stairs of the subway, insulting him or her on the physical handicap that prevents him or her from advancing faster in the line;\n• Call on the Internet violence against a religious figure, a community representative or a person closely associated with an identifiable group.",
//                            ""]
//        var nbArray = ["N.B. : These acts, in isolation, are not punishable by law, even though they may affect the sense of security of the targeted person. However, if these actions become repetitive, they could eventually constitute harassment and become hate crime.",
//                       "Legal applications\n\nCriminal Code:\n- Art. 298 (1): Libelous libel\n- Art. 318 (4): Identifiable group\n- Art. 319 (1) and (2): Public Incentive to the hate / willfully foment hatred",
//                       "Legal applications\n\nCanadian Human Rights Act\n\nCharter of Rights and Freedoms:\n- Art. 10, 10.1, 11, 12, 13, 15, 16, 17, 18, 18.1, 18.2, 19: Chapter I.1 \n- Right to equality in the recognition and exercise of rights and freedoms",
//                       "Legal Applications Criminal Code:\n\n- Art. 264.1: Uttering threats\n- Art. 423 (1): Intimidation",
//                       "Legal applications\n\nCriminal Code:\n\n- Art. 264 (1) and (2): Criminal harassment\n- Art. 372 (1), (2) and (3): False Information, indecent communications, harassing communications\n- Art. 423 (1): Intimidation\nCanadian Human Rights Act:\n- Art. 14 (1) and (2): Harassment, harassment sexual\nAct respecting labor standards:\n- Art. 81.18 and 81.19: Harassment psychological",
//                       "Legal applications\n\nCriminal Code:\n\n- Art. 430 (1) - (1.1) - (4.1) - (4.11) - (4.2) -\n(5): Harms",
//                       "Legal applications\n\nCriminal Code:\n\n- Section 265 (1): Assaults\n- Article 343: Robbery\n- Art. 318 (1) Encouragement of genocide\n- Art. 318 (4): Identifiable group",
//                       ""]
//        var iconImgArray = ["ic_category_injurious", "ic_category_offensive", "ic_category_discrimination", "ic_category_threat",
//                            "ic_category_harassment", "ic_category_degradation", "ic_category_violence", "ic_category_more"]
//        var isSelectedArray = [false, false, false, false, false, false, false, false]
//
//        for i in 0...titleArray.count - 1 {
//            let factorData: FactorData = FactorData.init(title: titleArray[i], info: infoArray[i], iconImg: iconImgArray[i], isSelected: isSelectedArray[i], example: exampleArray[i], nb: nbArray[i])
//            categoryArray.append(factorData)
//        }
//
//        categoryCollectionView.reloadData()
//    }

//    func initFactorData() {
//        var titleArray = ["Age", "Handicap", "Sex / Gender", "Race / Ethnicity", "Religion", "Sexual Orientation", "Social Condition", "Physical Appearance", "Other"]
//        var infoArray = ["Age-related hate crimes and incidents are acts that target a person who is because of a prejudice on his age. This type of incident and crime affects primarily, but not exclusively, the elderly.",
//                         "A disability refers to any condition that is a physical, mental, intellectual or sensory barrier to function fully in society or participate in community life. A disability can be more or less severe, and can be more or less visible. Hate crimes and incidents motivated by a person's disability are acts that target an individual because of their disability.",
//                         "A hate crime or incident motivated by the sex of a person or gender is an act that targets that person because of his or her real or perceived status as a man, woman, or other gender identity or expression ( transgender, intersex, etc.).",
//                         "Hate crimes and incidents motivated by race or ethnicity are acts that target a person on the basis of racial origin, ethnic identity, color, belonging to a particular cultural group, or nationality, whether these are real or perceived.",
//                         "Hate crimes and incidents motivated by religion are acts that target a nobody because of his beliefs, or his belonging (real or assumed) to a religion.",
//                         "Hate crimes and incidents motivated by sexual orientation are acts that target a person because of bias because of their actual or perceived sexual preference. Sexual orientation includes heterosexuality, homosexuality, bisexuality, pansexuality or asexuality.",
//                         "Hate crimes and incidents motivated by social condition are acts that target a person because of a prejudice about their socio-economic status, including their class, income, standard of living, level of education or neighborhood.",
//                         "Hate crimes and incidents motivated by physical appearance are acts that target a person because of their external appearance (birthmark, physical abnormality, overweight, etc.) or their dress (visible belonging to a person). counterculture, eccentric or unconventional dress, etc.).",
//                         "Select this category if the incident or hate crime you want to report does not seem to fit into one of the proposed categories."]
//        var iconImgArray = ["ic_factor_age", "ic_factor_handicap", "ic_factor_gender", "ic_factor_race", "ic_factor_religion",
//                            "ic_factor_sexual", "ic_factor_social", "ic_factor_appearance", "ic_category_more"]
//        var isSelectedArray = [false, false, false, false, false, false, false, false, false]
//
//        for i in 0...titleArray.count - 1 {
//            let factorData: FactorData = FactorData.init(title: titleArray[i], info: infoArray[i], iconImg: iconImgArray[i], isSelected: isSelectedArray[i], example: "", nb: "")
//            factorArray.append(factorData)
//        }
//        
//        factorCollectionView.reloadData()
//    }

//    func initFilterData() {
//        var titleArray = ["Emergency", "Listening", "Psychosocial Accompaniment", "Support Groups", "Health and Social Services", "Legal Aid", "Accommodation", "Underage persons", "Free Resources"]
//        var infoArray = ["Resources available immediately, 24/7, for urgent assistance needed by victims of incidents or hate crimes (care, accommodation, listening, etc.).",
//                         "Listening services to support victims of incidents or hate crimes, as well as their loved ones or witnesses.",
//                         "Personalized or collective psychosocial support services dedicated to assessing the status of victims of incidents or hate crimes (shock, trauma), their potential needs and the resources to be put in place.",
//                         "Support Resources collective offering a range of activities to support the mutual support of victims of hate crimes or incidents and the sharing of their experience.",
//                         "Resources in the Health and Services Network social services (hospitals, health organizations, community services) providing medical or social care to victims of incidents or hate crimes.",
//                         "Legal aid services (criminal prosecution, filing of a complaint, defense of rights) available to victims or witnesses of incidents or hate crimes.",
//                         "Accommodation resources that can temporarily accommodate, and if needed, victims or witnesses of incidents or hate crimes.",
//                         "Medical, psychosocial or listening resources intended primarily for minor clients, able to intervene with victims or witnesses of incidents or hate crimes under 18 years of age.",
//                         "Resources available free of charge to victims or witnesses of incidents or hate crimes."]
//        var iconImgArray = ["ic_filter_emergency", "ic_filter_listening", "ic_filter_support", "ic_filter_group", "ic_filter_health",
//                            "ic_filter_help", "ic_filter_accommo", "ic_filter_people", "ic_filter_free"]
//        var isSelectedArray = [false, false, false, false, false, false, false, false, false]
//
//        for i in 0...titleArray.count - 1 {
//            let factorData: FactorData = FactorData.init(title: titleArray[i], info: infoArray[i], iconImg: iconImgArray[i], isSelected: isSelectedArray[i], example: "", nb: "")
//            filterArray.append(factorData)
//        }
//
//        filterCollectionView.reloadData()
//    }

    func onSaveEthnicData() {
        
        for i in 0...ethnicArray.count - 1 {
            
            let motherTongue = PFObject(className: Constants.CLASS_ETHNIC)
            motherTongue["order"] = i
            motherTongue["name"] = ethnicArray[i]
            if i > ethnicfrArray.count - 1 {
                motherTongue["name_fr"] = ""
            } else {
                motherTongue["name_fr"] = ethnicfrArray[i]
            }
            motherTongue.saveInBackground()
        }
    }
    
    func onSaveReligionData() {
        
        for i in 0...religionArray.count - 1 {
            
            let motherTongue = PFObject(className: Constants.CLASS_RELIGION)
            motherTongue["order"] = i
            motherTongue["name"] = religionArray[i]
            if i > religionfrArray.count - 1 {
                motherTongue["name_fr"] = ""
            } else {
                motherTongue["name_fr"] = religionfrArray[i]
            }
            motherTongue.saveInBackground()
        }
    }

    func onSaveLanguageData() {
        
        for i in 0...languagefrArray.count - 1 {
            
            let motherTongue = PFObject(className: Constants.CLASS_MOTHER_TONGUE)
            motherTongue["order"] = i
            motherTongue["name_fr"] = languagefrArray[i]
            if i > languageArray.count - 1 {
                motherTongue["name"] = ""
            } else {
                motherTongue["name"] = languageArray[i]
            }
            motherTongue.saveInBackground()
        }
    }
    
    func onSaveKnowMoreData() {
        
        for i in 0...learnArray.count - 1 {
            
            let knowMore = PFObject(className: Constants.CLASS_KNOW_MORE)
            knowMore["order"] = i
            knowMore["title"] = learnArray[i]
            knowMore["title_fr"] = learnfrArray[i]
            knowMore["weblink"] = "https://www.malamo.com/knowmore/"
            knowMore.saveInBackground()
        }
    }
    
    func saveReportData() {
        let myReport = PFObject(className: Constants.CLASS_REPORT)
        myReport["trackingNumber"] = "2SY8HKZ"
        myReport["reportStatus"] = "Processing..."
        myReport["reportType"] = "Witness"
        myReport["incidentDescription"] = "incident description"
        myReport["incidentOccurType"] = "Physical address"
        myReport["incidentDate"] = "2018/01/10"
        myReport["incidentTime"] = "08:10"
        myReport["incidentAddressDesc"] = "Address"
        myReport["incidentAddress"] = "Quebec"
        myReport["city"] = "Quebec"
        myReport["transportMode"] = ""
        myReport["serviceNumber"] = ""
        myReport["onlinePlatform"] = ""
        myReport["url"] = ""
        myReport["peopleNumber"] = "2"
        myReport["hasAggressor"] = true
        myReport["isVictim"] = true
        myReport["hasVictim"] = false
        myReport["isAnonym"] = false
        myReport["userLastName"] = "last name"
        myReport["userFirstName"] = "first name"
        myReport["userEmail"] = "email@email.com"
        myReport["userPhone"] = "3423423423"
        myReport.saveInBackground { (success, error) in
            if (success) {
                // The object has been saved.
                for i in 0...3 {
                    let aggressor = PFObject(className: Constants.CLASS_AGGRESSOR)
                    aggressor["lastname"] = "last name"
                    aggressor["firstname"] = "first name"
                    aggressor["gender"] = "man"
                    aggressor["ageRange"] = "20"
                    aggressor["ethnic"] = "canadian"
                    aggressor["specialSign"] = "signs"
                    aggressor["report"] = PFObject(withoutDataWithClassName:Constants.CLASS_REPORT, objectId:myReport.objectId)
                    aggressor.saveInBackground(block: { (success, error) in
                        if success {
                            let relation = myReport.relation(forKey: "aggressor")
                            relation.add(aggressor)
                            myReport.saveInBackground()
                        } else {
                            
                        }
                    })
                }
            } else {
                // There was a problem, check error.description
            }
        }
    }
    
    func getOrganismData() {
        
        let query = PFQuery(className: Constants.CLASS_ORGANISM)
        query.findObjectsInBackground (block: { (objects, error) in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let name = GlobalData.onCheckStringNull(object: object, key: "name")
                        let email = GlobalData.onCheckStringNull(object: object, key: "email")
                        let phone = GlobalData.onCheckStringNull(object: object, key: "phoneNumber")
                        let coordinate = object["coordinates"] as? PFGeoPoint
                        let categoryRelation = object.relation(forKey: "categoryIds")
                        var categoryIds = [String]()
                        categoryRelation.query().findObjectsInBackground(block: { (relations, error) in
                            if error == nil {
                                if let relations = relations {
                                    for relation in relations {
                                        categoryIds.append(relation.objectId!)
                                    }
                                    
                                    let organismData = OrganismData.init(name: name, email: email, phoneNumber: phone, latitude: (coordinate?.latitude)!, longitude: (coordinate?.longitude)!, categoryIds: categoryIds)
                                    GlobalData.organismArray.append(organismData)
                                }
                            }
                        })
                    }
                }
            }
        })
    }
}

