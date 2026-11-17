# README file for datasets and scripts of `TrustInScience` project 

* This document provides information about the data files and scripts used in `TrustInScience` data analysis, corresponding to the paper *Knowledge of the nature of science predicts university students’ trust in science irrespective of political ideology and degree*. 

## Outline of contents

````
├──── *README.md
├──── Data
│ └─── Data_01.csv
└──── Scripts
  ├── Scripts_01-DemographicAnalyses.R
  ├── Scripts_02-TestAssessments.R
  ├── Scripts_03-Relationships.R
  └── Scripts_04-Inconsistencies.R
````

## `Data` folder

* This folder contains the raw dataset used in the different scripts. 

* It contains the following variables, structured in four groups: `Control`, `Demographics`, `Socio-political profile`, `Religiosity`, `Trust in Science`, and `Knowledge of the Nature of Science`.

### Control

**Date**: Timestamp indicating when the survey was completed. Corresponds to the survey's "*Marca temporal*".

**Code**: Control variable with the code used to get into the Google Forms survey. Corresponds to the survey's "*Código de Verificación (escriba la palabra clave para continuar haciendo el test)*". See `*TIS_DC_RF_MetaData.xlsx` for correspondences with universities and degrees. 

**SourceFile**: Control variable for where the data comes from (i.e., which raw data file, as extracted from Google Forms). 

**Individual_ID**: Individual respondent number, to easily locate individual cases. 

### Demographics

**University**: University to which the respondent belongs. It can be: UA (Universidad de Alicante), UAM (Universidad Autónoma de Madrid), UCM (Universidad Complutense de Madrid), UGR (Universidad de Granada), UIB (Universitat de les Illes Balears), US (Universidad de Sevilla), UPO (Universidad Pablo de Olavide; only History), USAL (Universidad de Salamanca), USC (Universidade de Santiago de Compostela), UV (Universitat de Valencia; only Biology), UVigo (Universidade de Vigo).  

**Region**: Region (Comunidad Autónoma) to which the university belongs. It can be: Valencia, Madrid, Andalusia, Balearic Islands, Castile and Leon, Galicia. 

**Degree**: Degree to which the respondent belongs. It can be: Biology ("Grado en Biología"), Chemistry ("Grado en Química"), History ("Grado en Historia"), English (generally "Grado en Estudios Ingleses"). For certain analyses, it can be considered a factor, while in others it's a character variable. 

**Gender**: Gender/Sex with which the respondent identifies. It can take `Female`, `Male`, `PreferNotToSay`, and `Other` values. Corresponds to the survey question of: "*¿Con qué sexo se identifica?*".

**Age**: Age of the respondent. Corresponds to the survey question of: "*Indique su edad*". 

**AcademicAchievement**: Maximum academic achievement of the respondent. Corresponds to the survey question of: "*Máximo nivel académico logrado*". Has the following correspondence:
	
	"Formacion Profesional" = "VocationalTraining"
	"Bachiller" = "HighSchool"
	"Graduado" = ""Master" = "Master"
	"Doctor" = "PhD"

**AcademicItinerary**: High school itinerary of the respondent. Corresponds to the survey question of: "*Itinerario principal seguido durante la educación obligatoria*". Has the following correspondence:

	"Ciencias" = "NaturalSciences"
	"Humanidades" = "Humanities"
	"Tecnologico" = "Technology"
	"Ciencias Sociales" = "SocialSciences"
	"Arte" = "Art"
	
**RegionOfOrigin**: Region of Spain or country of origin of birth with respect to the university where the respondent is enrolled. Corresponds to the survey question of: "*Origen de nacimiento*". Has the following correspondence:

	"Misma comunidad autonoma a la de la universidad donde estudia" = "SameRegion"
	"Otra comunidad autonoma a la de la universidad donde estudia" = "DifferentRegion"
	"Otro pais miembro de la Union Europea" = "OtherEUCountry"
	"Un pais americano latino" = "LatinAmerica"
	"Otro pais europeo no comunitario" = "EuropeanNonEUCountry"
	"Cualquier otro pais" = "Other"

### Socio-political profile

**PoliticalPosition**: Ideological self-positioning of the respondent, on a scale from 1 (extreme left) to 10 (extreme right). Corresponds to the survey question of: "*Cuando se habla de política se utilizan normalmente las expresiones «izquierda» y «derecha» . En una escala que va del 1 al 10, en la que 1 significa  «lo más a la izquierda » y 10  «lo más a la derecha» , ¿Donde se colocaría usted?*". Question adapted from the Spanish Institute for Sociology (CIS) surveys. 

**EconomicSituation_Personal**: Self-perceived economic situation of the respondent. Corresponds to the survey question of: "*¿Cómo calificaría su situación económica PERSONAL en la actualidad?*". Question inspired by the Spanish Institute for Sociology (CIS) surveys. Has the following correspondence:

	"Muy mala" = "Very bad" = "1" 
	"Mala" = "Bad" = "2",
	"Regular" = "Fair" = "3"
	"Buena" = "Good" ="4"
	"Muy buena" = "Very good" = "5"

**EconomicSituation_Family**: Perceived economic situation of the respondent's family. Corresponds to the survey question of: "*¿Cómo calificaría su situación económica FAMILIAR en la actualidad?*". Question inspired by the Spanish Institute for Sociology (CIS) surveys. Has the following correspondence:

	"Muy mala" = "Very bad" = "1" 
	"Mala" = "Bad" = "2",
	"Regular" = "Fair" = "3"
	"Buena" = "Good" ="4"
	"Muy buena" = "Very good" = "5"
	
**ClimateChangeConcern**: Concern for climate change of the respondent. Corresponds to the survey question of: "*¿Cuanto diría Ud. que le preocupa en estos momentos el cambio climático?*".
Question inspired by the Spanish Institute for Sociology (CIS) surveys. Has the following correspondence: 

	"Nada" = "Nothing" = "1"
	"Poco" = "Little" = "2"
	"Regular" = "Moderate/Regular" = "3"
	"Bastante" = "Quite" = "4"
	"Mucho" = "A lot" = "5"

### Religiosity

**DUREL_01**: Back-translated first question of the 5-item DUREL scale (Koenig et al. 1997). Corresponds to the survey question of: "*¿Con qué frecuencia asistes a la iglesia u otras reuniones religiosas?*". Has the following correspondence:

	"Nunca" = "Never" = "0"
	"Una vez al año o menos" = "Once a year or less" = "1"
	"Unas pocas veces al año" = "A few times a year" = "2"
	"Unas pocas veces al mes" = "A few times a month" = "3"
	"Una vez a la semana" = "Once a week" = "4"
	"Más de una vez a la semana" = "More than once a week" = "5"

**DUREL_02**: Back-translated second question of the 5-item DUREL scale (Koenig et al. 1997). Corresponds to the survey question of: "*¿Con qué frecuencia pasas el tiempo en actividades religiosas privadas, como la oración, la meditación o el estudio de textos religiosos?*". Has the following correspondence:

	"Nunca" = "Never" = "0"
	"Una vez al año o menos" = "Once a year or less" = "1"
	"Unas pocas veces al año" = "A few times a year" = "2"
	"Unas pocas veces al mes" = "A few times a month" = "3"
	"Una vez a la semana" = "Once a week" = "4"
	"Más de una vez a la semana" = "More than once a week" = "5"
	
**DUREL_03**: Back-translated third question of the 5-item DUREL scale (Koenig et al. 1997). Corresponds to the survey question "*En mi vida, experimento la presencia de lo Divino (es decir, Dios).*". Has the following correspondence:

	"Definitivamente, no es cierto" = "Definitely not true" = "1"
	"Mas bien no" = "Probably not true" = "2"
	"No lo tengo claro" = "Not sure" = "3"
	"Mas bien si" = "Probably true" = "4"
	"Definitivamente, es cierto" = "Definitely true" = "5"
	
**DUREL_04**: Back-translated fourth question of the 5-item DUREL scale (Koenig et al. 1997). Corresponds to the survey question of: "*Mis creencias religiosas son lo que realmente importa a todo mi enfoque de la vida.*". Has the following correspondence:

	"Definitivamente, no es cierto" = "Definitely not true" = "1"
	"Mas bien no" = "Probably not true" = "2"
	"No lo tengo claro" = "Not sure" = "3"
	"Mas bien si" = "Probably true" = "4"
	"Definitivamente, es cierto" = "Definitely true" = "5"

**DUREL_05**: Back-translated fifth question of the 5-item DUREL scale (Koenig et al. 1997).Corresponds to the survey question of: "*Me esfuerzo por trasladar mi religión a todos los demás aspectos de la vida.*" Has the following correspondence:

	"Definitivamente, no es cierto" = "Definitely not true" = "1"
	"Mas bien no" = "Probably not true" = "2"
	"No lo tengo claro" = "Not sure" = "3"
	"Mas bien si" = "Probably true" = "4"
	"Definitivamente, es cierto" = "Definitely true" = "5"

### Trust in Science

**Trust_01_r**: Back-translated first question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*1.  Cuando los científicos cambian de opinión sobre una idea científica disminuye mi confianza en su trabajo.*". Has the following correspondence: 

	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"

**Trust_02_r**: Back-translated second question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*2. Los científicos ignoran las evidencias que contradicen su trabajo.*". Has the following correspondence: 

	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"
	 
**Trust_03_r**: Back-translated third question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*3. Las teorías científicas son explicaciones poco convincentes*". Has the following correspondence: 

	 	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"
	 
**Trust_04_r**: Back-translated fourth question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*4. Los científicos mantienen su trabajo en secreto de forma intencionada*". Has the following correspondence: 

	 	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"

**Trust_05_f**: Back-translated fifth question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*5. Podemos confiar en que los científicos compartirán los resultados de sus investigaciones, aunque no les gusten.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"

**Trust_06_r**: Back-translated sixth question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*6. Los científicos no valoran las ideas de los demás*". Has the following correspondence: 

	 	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"

**Trust_07_f**: Back-translated seventh question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*7. Confío en que el trabajo de los científicos mejore la vida de las personas.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"

**Trust_08_r**: Back-translated eighth question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*8. A los científicos no les importa que los profanos entiendan su trabajo.*". Has the following correspondence: 

	 	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"

**Trust_09_f**: Back-translated ninth question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*9. Deberíamos confiar en el trabajo de los científicos*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"

**Trust_10_f**: Back-translated tenth question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*10. Deberíamos confiar en que los científicos sean honestos en su trabajo.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"

**Trust_11_f**: Back-translated eleventh question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*11. Deberíamos confiar en que los científicos sean éticos en su trabajo.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"

**Trust_12_f**: Back-translated twelfth question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*12. Las teorías científicas son fiables.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"

**Trust_13_r**: Back-translated 13th question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*13. Cuando los científicos formulan una hipótesis solo están suponiendo.*". Has the following correspondence: 

	 	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"

**Trust_14_f**: Back-translated 14th question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*14.  Las personas que entienden más la ciencia confían más en ella.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"

**Trust_15_f**: Back-translated 15th question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*15. Podemos confiar en la ciencia para encontrar las respuestas que expliquen el mundo natural.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"

**Trust_16_f**: Back-translated 16th question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*16. Confío en que los científicos puedan encontrar soluciones a nuestros principales problemas tecnológicos.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"

**Trust_17_r**: Back-translated 17th question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*17. No podemos confiar en los científicos porque sus opiniones están sesgadas.*". Has the following correspondence: 

	 	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"

**Trust_18_r**: Back-translated 18th question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*18. Los científicos se protegerán entre sí aunque se equivoquen.*". Has the following correspondence: 

	 	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"

**Trust_19_r**: Back-translated 19th question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*19. No podemos confiar en que los científicos consideren ideas que contradicen las suyas.*". Has the following correspondence: 

	 	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"

**Trust_20_r**: Back-translated 20th question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*20. Los científicos de hoy sacrificarán el bienestar de los demás para avanzar en su investigación.*". Has the following correspondence: 

	 	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"

**Trust_21_r**: Back-translated 21st question of the Trust in Science and Scientists Inventory (Nadelson et al. 2014). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*21. No podemos confiar en la ciencia porque avanza con demasiada lentitud.*". Has the following correspondence: 

	 	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"

### Knowledge of the Nature of Science

**NOS_01_f**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*1. Las teorías científicas, para ser aceptadas, deben estar apoyadas por múltiples evidencias.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"

**NOS_02_r**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*2. Las nuevas hipótesis son básicamente conjeturas descabelladas; los científicos simplemente las imaginan.*". Has the following correspondence:
 
	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"

**NOS_03_f**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*3. Las teorías científicas aceptadas son explicaciones bien fundamentadas de un amplio conjunto de fenómenos naturales.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"	 	
**NOS_04_r**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*4. Las teorías son básicamente corazonadas; aún no han acumulado suficientes evidencias para ser consideradas hipótesis.*". Has the following correspondence:
 
	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"
 
**NOS_05_f**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*5. La misma hipótesis o teoría se verifica a menudo de muchas maneras diferentes.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"	 	
**NOS_06_r**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*6. Las investigaciones científicas no podrían avanzar sin experimentos de laboratorio.*". Has the following correspondence:
 
	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"
	 
**NOS_07_f**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*7. El proceso de la ciencia no es lineal; cada paso puede conducir a muchos otros posibles.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"	 	
**NOS_08_r**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*8. Los científicos siempre siguen el mismo método científico paso a paso.*". Has the following correspondence:
 
	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"	 	 	 		
	 	 	 		
	 
**NOS_09_f**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*9. El conocimiento científico se construye siguiendo un proceso complejo que se basa, en parte, en la observación de la naturaleza.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"	 	
**NOS_10_r**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*10. El conocimiento científico se deduce directamente de las observaciones de la naturaleza.*". Has the following correspondence:
 
	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"	 	 	 	 		
	 	 	 		
**NOS_11_f**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*11. Las teorías científicas están sujetas a continuas verificaciones y revisiones.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"	 	
**NOS_12_r**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*12. Las teorías científicas basadas en experimentos rigurosos no se modificarán.*". Has the following correspondence:
 
	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"	

**NOS_13_f**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*13. Las investigaciones científicas suelen dar lugar a preguntas adicionales para seguir investigando.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"	 	
**NOS_14_r**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*14. Las investigaciones científicas suelen llegar a una conclusión definitiva, lo que permite a la ciencia avanzar hacia una nueva pregunta.*". Has the following correspondence:
 
	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"	

**NOS_15_f**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*15. El objeto de la verificación científica es descubrir qué explicación de un fenómeno tiene más probabilidades de ser correcta.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"	 	
**NOS_16_r**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*16. Los científicos suelen investigar a fondo una hipótesis antes de pensar en explicaciones alternativas.*". Has the following correspondence:
 
	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"	

**NOS_17_f**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*17. Los científicos utilizan su imaginación y creatividad para idear nuevos experimentos, hipótesis y teorías.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"	 	
**NOS_18_r**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*18. Los científicos no utilizan su imaginación y creatividad porque pueden interferir con la objetividad.*". Has the following correspondence:
 
	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"	
 	 		
**NOS_19_f**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*19. La comunidad científica es esencial para el proceso y el progreso de la ciencia.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"	 	
**NOS_20_r**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*20. A diferencia de muchas otras profesiones, la ciencia es casi siempre una tarea solitaria.*". Has the following correspondence:
 
	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"	

**NOS_21_f**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). Corresponds to the survey question of: "*21. Los problemas y observaciones cotidianas suelen inspirar investigaciones científicas.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"	 	
**NOS_22_r**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*22. La ciencia es pura; los científicos se esfuerzan por hacer su trabajo sin considerar sus posibles aplicaciones.*". Has the following correspondence:
 
	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"	
 	 	 				 	 	 	 		 	 
**NOS_23_f**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_f` suffix indicates it is a forward coded item. Corresponds to the survey question of: "*23.  Los científicos se ven influenciados por sus sociedades y culturas, lo que a su vez, influye en su trabajo científico.*". Has the following correspondence: 

	"Totalmente en desacuerdo" = "Strongly disagree" = "1"
	"En desacuerdo" = "Disagree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"De acuerdo" = "Agree" = "4" 
	"Totalmente de acuerdo" = "Strongly agree" = "5"	 	
**NOS_24_r**: Back-translated first question of the sample of the Nature of Science Inventory displayed in Lombrozo et al. (2008). The `_r` suffix indicates it is a reverse coded item. Corresponds to the survey question of: "*24.   La sociedad y la cultura no influyen en la investigación científica, porque los científicos están preparados para realizar estudios “puros"" e imparciales.*". Has the following correspondence:
 
	"Totalmente de acuerdo" = "Strongly agree" = "1"
	"De acuerdo" = "Agree" = "2"
	"Ni de acuerdo ni en desacuerdo" = "Neither agree nor disagree" = "3"
	"En desacuerdo" = "Disagree" = "4"
	 "Totalmente en desacuerdo" = "Strongly disagree" = "5"	

## `Scripts` folder

This folder contains the R scripts used for data curation, statistical analyses, and figure preparation. The scripts are organized according to the main research questions addressed in the manuscript, broadly following the order in which the analyses are presented.

The scripts primarily use the merged raw dataset (`TrusSci`) and its curated version (`TrusSci_Clean`). Some analyses use further subsets of the curated dataset, depending on the variables and statistical models involved.

All scripts follow the same basic structure:

- **BASIC INFO:** Describes the script's aim, the researcher responsible, and the dates of creation and last update.
- **SETUP SECTION:** Loads the required R packages and datasets, prepares relevant variables, and defines graphical themes.
- **ANALYSIS SECTION:** Contains the code for data processing, statistical analyses, model diagnostics, tables, and figures. Analyses are organized into numbered subsections corresponding to the questions addressed in the manuscript and Supplementary Information.

### `Scripts_01-DemographicAnalyses`

This script aims to curate the raw dataset, describe the demographic characteristics of the sample, and explore associations between relevant sociodemographic variables.

The **ANALYSIS SECTION** includes:

- **1. Data curation:** Identification and exclusion of problematic observations, including respondents outside the target age range and implausible demographic records.
- **2. Sample summary (Table 1):** Descriptive statistics for university, degree, gender, academic achievement, academic itinerary, geographical origin, and age.
- **3. Political ideology:** Comparison of students' political positions with the Spanish general population, and assessment of the associations between political ideology, degree, and gender.
- **4. Climate change:** Analysis of the relationship between political ideology and concern for climate change, including regression analyses and model diagnostics.

### `Scripts_02_TestAssessments`

This script aims to assess the psychometric properties of the questionnaires used in the study.

The **ANALYSIS SECTION** includes:

- **1. Trust in Science and Scientists (TiSS) inventory:** Item-level descriptive statistics, reliability analyses using Cronbach's alpha and McDonald's omega, assessment of factorability, exploratory factor analysis, and confirmatory factor analysis of the selected factor structure.
- **2. Nature of Science (NoS) inventory:** Item-level descriptive statistics, comparison with the results of Lombrozo et al. (2008), reliability analyses, and exploratory factor analysis to identify the underlying dimensions of the questionnaire.
- **3. Duke Religion (DUREL) Index:** Descriptive statistics of religiosity measures and reliability assessment of the intrinsic religiosity subscale.

### `Scripts_03-Relationships`

This script aims to identify the principal predictors of trust in science among Spanish university students, particularly the contribution of knowledge of the nature of science relative to sociodemographic and ideological factors.

The **ANALYSIS SECTION** includes:

- **1. What predicts trust in science?:** Assessment of the relationship between NoS knowledge and trust in science while controlling for degree, political ideology, intrinsic religiosity, climate change concern, and gender (Table 2).
- **4. Exploratory causal model:** Path analysis of the hypothetizised main causal chains at work.

### `Scripts_04-Inconsistencies`

This script aims to explore potential causal pathways connecting educational and sociodemographic variables with trust in science, and to investigate inconsistencies in students' responses to selected NoS items.

The **ANALYSIS SECTION** includes:

- **1. Mapping response inconsistencies:** Identification and visualization of inconsistent responses to the paired items comprising the Testing, Nonlinearity, and Construction themes of the NoS questionnaire.
- **2. Linear regression:** Assessment of whether the number of consistent and scientifically correct response profiles predicts NoS knowledge, excluding the six items from the problematic themes.
- **5. Inconsistencies among top- and bottom-scorers:** Chi-square tests examining whether consistent and inconsistent response profiles differ between students in the upper and lower quartiles of NoS scores, with Cramér's V as the measure of association.
