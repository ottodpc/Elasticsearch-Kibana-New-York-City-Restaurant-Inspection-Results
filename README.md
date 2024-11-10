# NYC Restaurant Inspection Results Analysis 📊🍽️

## Description 📝

Ce projet vise à analyser les données d'inspection des restaurants de New York à l'aide de la pile Elastic (Elasticsearch, Kibana, Filebeat, Metricbeat, Logstash). En utilisant l'API Elastic et les visualisations Kibana, l'objectif est de répondre à une série de questions et d'explorer les violations les plus fréquentes dans les restaurants de la ville.

## Table des Matières

1. [Objectif](#instructions)
2. [Installation et Configuration](#installation-et-configuration)
3. [Utilisation du Projet](#utilisation-du-projet)
4. [Exemples de Requêtes et Visualisations](#exemples-de-requêtes-et-visualisations)
5. [Création du Dashboard Kibana](#création-du-dashboard-kibana)
6. [Visualisation](#exportation-du-rapport)

## Objectif 🛠️

L’objectif est de répondre aux questions en utilisant l'API Elastic et les visualisations Kibana.

**Liens de référence** :

- [Documentation Elastic Stack Setup](https://www.elastic.co/blog/getting-started-with-the-elastic-stack-and-docker-compose)
- [Données d'étude : NYC Restaurant Inspection](https://data.cityofnewyork.us/Health/DOHMH-New-York-City-Restaurant-Inspection-Results/43nn-pn8j/about_data)

## Installation et Configuration d'Elasticsearch et Kibana

### Prérequis

- Docker et Docker Compose
- Données d'étude : NYC Restaurant Inspection

### Étapes d'Installation

1. Clonez le dépôt :

   ```bash
   git clone https://github.com/ottodpc/Elasticsearch-Kibana-New-York-City-Restaurant-Inspection-Results.git
   cd Elasticsearch-Kibana-New-York-City-Restaurant-Inspection-Results
   ```

2. Configurez les variables d'environnement dans le fichier `.env` :

   ```plaintext
   ELASTIC_PASSWORD=ottodpc-azerty123
   KIBANA_PASSWORD=ottodpc-azerty123
   STACK_VERSION=8.7.1
   CLUSTER_NAME=nyc-restaurants-cluster
   LICENSE=basic
   ES_PORT=9200
   KIBANA_PORT=5601
   ES_MEM_LIMIT=1073741824
   KB_MEM_LIMIT=1073741824
   ENCRYPTION_KEY=c34d38b3a14956121ff2170e5030b471551370178f43e5626eec58b04a30fae2
   ```

3. Lancez l'environnement Elastic Stack :
   ```bash
   docker-compose up -d --build
   ```
   ![Lancement Docker](./img/start.png)

## Utilisation du Projet

1. Accédez à Kibana sur `http://localhost:5601` et Elasticsearch sur `http://localhost:9200`.
2. Importez les données d'inspection de New York :

   - Accédez à "Integrations" > "Upload file" et sélectionnez le fichier `DOHMH_New_York_City_Restaurant_Inspection_Results.csv` via Kibana : `http://localhost:5601/app/home#/tutorial_directory/fileDataViz`

   ![Importation de données](./img/Elastic-upload-file-data.png)

   **Gestion des erreurs** :

   - En cas d'erreur de taille de fichier
     ![Erreur Importation](./img/error_File_size_too_large.png)
   - Augmenter la taille max.
     ![Erreur Importation Max size](./img/error_File_size_too_large_correction.png)

## Exemples de Requêtes et Visualisations

### Requêtes Elasticsearch 🔍

#### 1. Liste des quartiers de New York

```json
GET nyc_restaurants/_search
{
  "size": 0,
  "aggs": {
    "neighborhoods": {
      "terms": {
        "field": "NTA",
        "size": 1000
      }
    }
  }
}
```

![Requête 1](./img/q1.png)

#### 2. Quartier avec le plus de restaurants

```json
GET nyc_restaurants/_search
{
  "size": 0,
  "aggs": {
    "neighborhood_with_most_restaurants": {
      "terms": {
        "field": "NTA",
        "size": 1,
        "order": {
          "_count": "desc"
        }
      }
    }
  }
}
```

![Requête 2](./img/q2.png)

#### 3. Mapping

```json
GET nyc_restaurants/_mapping
```

![Requête 3](./img/index_name_nyc_restaurants_mapping_request_test.png)

### Autres Requêtes et Explications

- **Questions avec des requêtes Elastic API** :

  - Q1 : List all the neighborhoods in New York.

```json
GET nyc_restaurants/_search
{
  "size": 0,
  "aggs": {
    "neighborhoods": {
      "terms": {
        "field": "NTA",
        "size": 1000
      }
    }
  }
}
```

**Explication de la requête :**

- **"size": 0** : Seulement des résultats d'agrégation.
- **"aggs"** : Une agrégation pour regrouper les données.
- **"neighborhoods"** : Nom de l'agrégation, ici nous collectons les quartiers.
- **"terms"** : Type d'agrégation utilisée pour regrouper par termes uniques.
- **"field": "NTA"** : Champ sur lequel l'agrégation est effectuée, représentant les quartiers.
- **"size": 1000** : Nombre maximal de termes uniques à retourner, pour s'assurer que tous les quartiers sont inclus.

![requete](./img/q1.png)

Le résultat de la requête montre une agrégation des quartiers (NTA - Neighborhood Tabulation Areas) de New York, avec chaque quartier identifié par un code (ex. "MN17", "BK37") et le nombre d'occurrences de restaurants ou d'inspections pour chacun.

1. **Code du Quartier (key)** : Chaque entrée (ou "bucket") dans l'agrégation représente un quartier, identifié par son code unique. Par exemple :

   - **"MN17"** se réfère à un quartier spécifique dans Manhattan, avec un total de 14,356 documents.
   - **"BK37"** indique un quartier à Brooklyn avec 4,160 documents.

2. **Nombre de Documents (doc_count)** : Ce nombre montre combien de fois chaque quartier apparaît dans l'index "nyc_restaurants". Un chiffre élevé signifie qu'il y a beaucoup d'inspections ou de données concernant des restaurants dans cette zone. Ce champ peut être utilisé pour évaluer la densité d'activités de restauration ou d'inspections dans chaque quartier.

- Q2 : Which neighborhood has the most restaurants?

```json
GET nyc_restaurants/_search
{
  "size": 0,
  "aggs": {
    "neighborhood_with_most_restaurants": {
      "terms": {
        "field": "NTA",
        "size": 1,
        "order": {
          "_count": "desc"
        }
      }
    }
  }
}
```

**Explication de la requête :**

1. **"size": 0** : Seulement des résultats d'agrégation.
2. **"aggs"** : Une agrégation pour répondre à la question.
3. **"neighborhood_with_most_restaurants"** : Nom de l'agrégation utilisée pour regrouper les données par quartier.
4. **"terms"** : Type d'agrégation, permettant de compter les occurrences de chaque quartier.
5. **"field": "NTA"** : Champ utilisé pour identifier les quartiers.
6. **"size": 1** : Limite le retour au quartier ayant le plus grand nombre de documents.
7. **"order": { "\_count": "desc" }** : Tri décroissant par nombre de documents pour avoir le quartier avec le plus de restaurants en premier.

![requete](./img/q2.png)

Le quartier **MN17** a le plus grand nombre de restaurants dans l'ensemble de données. **"key": "MN17"** : Ce code représente un quartier spécifique de Manhattan (car "MN" correspond à Manhattan). **"doc_count": 14356** : Il y a 14,356 documents associés à ce quartier, ce qui représente le nombre total de restaurants dans cette zone. Cela signifie que MN17 est la zone avec le plus grand nombre de restaurants enregistrés dans l'index.

- Q3 : What does the violation code "04N" correspond to?

```json
GET nyc_restaurants/_search
{
  "query": {
    "term": {
      "VIOLATION CODE": "04N"
    }
  },
  "_source": ["VIOLATION DESCRIPTION"],
  "size": 1
}
```

**Explication de la requête :**

1. **"query": { "term": { "VIOLATION CODE": "04N" } }** : Nous utilisons une requête `term` pour rechercher exactement le code de violation "04N" dans le champ `VIOLATION CODE`.
2. **"\_source": ["VIOLATION DESCRIPTION"]** : Nous limitons les champs retournés aux seules descriptions des violations (pour réduire le volume de données inutiles).
3. **"size": 1** : Cette valeur est fixée à 1 car nous n'avons besoin que d'un document pour obtenir la description du code "04N".

![requete](./img/q3.png)

Cette description montre que la violation "04N" est liée à des infestations de mouches ou autres nuisances de type insectes dans des zones où cela pourrait présenter un risque pour l'hygiène alimentaire. Cette information est essentielle pour comprendre le type de problème que "04N" représente dans le contexte des inspections sanitaires des restaurants, car elle concerne des insectes nuisibles qui pourraient compromettre la sécurité alimentaire.

- Q4 : Where are the restaurants (name, address, neighborhood) that have a grade of A?

```json
GET nyc_restaurants/_search
{
  "query": {
    "term": {
      "GRADE": "A"
    }
  },
  "_source": ["DBA", "BUILDING", "STREET", "ZIPCODE", "NTA"],
  "size": 100
}
```

### La requête :

1. **"query": { "term": { "GRADE": "A" } }** : La requête utilise un filtre `term` pour sélectionner uniquement les documents où le champ `GRADE` est égal à "A".
2. **"\_source": ["DBA", "BUILDING", "STREET", "ZIPCODE", "NTA"]** : Nous limitons les champs retournés aux informations essentielles :
   - **"DBA"** : Nom du restaurant.
   - **"BUILDING"** et **"STREET"** : Adresse du restaurant.
   - **"ZIPCODE"** : Code postal pour plus de précision.
   - **"NTA"** : Quartier (Neighborhood Tabulation Area) où le restaurant est situé.
3. **"size": 100** : Limite le nombre de résultats retournés à 100 pour éviter de surcharger la réponse. Il est possible d'ajuster cette limite si nécessaire.

![requete](./img/q4.png)

Le résultat présente une liste de restaurants notés "A", classés sans ordre spécifique. Chaque entrée fournit :

**Nom du restaurant\*** : Permet de reconnaître l’établissement (utile pour des recommandations ou des analyses de qualité).
**_Adresse complète_** : Inclut le numéro de bâtiment, la rue et le code postal, facilitant la localisation géographique.
**_Quartier_** : Le code NTA permet de situer chaque restaurant dans un quartier précis de New York, ce qui peut aider à analyser la distribution de la note A dans les différents quartiers.

- Q5 : What is the most popular cuisine? And by neighborhood?

```json
GET nyc_restaurants/_search
{
  "size": 0,
  "aggs": {
    "most_popular_cuisine": {
      "terms": {
        "field": "CUISINE DESCRIPTION",
        "size": 1,
        "order": {
          "_count": "desc"
        }
      }
    },
    "popular_cuisine_by_neighborhood": {
      "terms": {
        "field": "NTA",
        "size": 100
      },
      "aggs": {
        "top_cuisine_in_neighborhood": {
          "terms": {
            "field": "CUISINE DESCRIPTION",
            "size": 1,
            "order": {
              "_count": "desc"
            }
          }
        }
      }
    }
  }
}
```

![requete](./img/q5.png)

Le résultat révèle une forte prévalence de la cuisine américaine, tant au niveau global qu’au sein de nombreux quartiers spécifiques. Cependant, certains quartiers montrent des préférences culinaires différentes, reflétant une diversité culturelle. Par exemple :

- **Cuisine chinoise** dans certains quartiers de Queens (ex. QN22).
- **Cuisine caribéenne** dans plusieurs quartiers de Brooklyn (ex. BK61, BK50).
- **Cuisine Jewish/Kosher** également bien représentée dans certains quartiers de Brooklyn (BK25, BK88).

Cela montre non seulement les préférences globales, mais aussi des préférences culinaires spécifiques à chaque quartier, permettant une analyse précise de la répartition des types de cuisines à travers la ville de New York.

- Q6 : What is the date of the last inspection?

```json
GET nyc_restaurants/_search
{
  "size": 1,
  "sort": [
    {
      "INSPECTION DATE": {
        "order": "desc"
      }
    }
  ],
  "_source": ["INSPECTION DATE"]
}
```

### La requête :

2. **"sort"** : Nous trions les documents par date d’inspection (`INSPECTION DATE`) en ordre décroissant (`"order": "desc"`), de sorte que la date la plus récente apparaisse en premier.
3. **"\_source": ["INSPECTION DATE"]** : Nous limitons le retour aux informations sur la date d’inspection uniquement, pour réduire le volume de données inutiles.

![requete](./img/q6.png)

Le résultat montre que la dernière inspection enregistrée a eu lieu le **11 juillet 2024**.

- Q7 : Provide a list of Chinese restaurants with an A grade in Brooklyn.

```json
GET nyc_restaurants/_search
{
  "query": {
    "bool": {
      "must": [
        { "term": { "GRADE": "A" } },
        { "term": { "CUISINE DESCRIPTION": "Chinese" } },
        { "term": { "BORO": "BROOKLYN" } }
      ]
    }
  },
  "_source": ["DBA", "BUILDING", "STREET", "ZIPCODE", "CUISINE DESCRIPTION", "GRADE"],
  "size": 100
}
```

### La requête :

1. **"query": { "bool": { "must": [...] } }** : Nous utilisons une requête booléenne avec des conditions `must` pour filtrer selon plusieurs critères.
   - **{ "term": { "GRADE": "A" } }** : Filtre les restaurants ayant une note "A".
   - **{ "term": { "CUISINE DESCRIPTION": "Chinese" } }** : Filtre les restaurants de cuisine chinoise.
   - **{ "term": { "BORO": "BROOKLYN" } }** : Limite les résultats aux restaurants situés dans le quartier de Brooklyn.
2. **"\_source": [...]** : Limite les champs retournés aux informations nécessaires :

   - **"DBA"** : Nom commercial du restaurant.
   - **"BUILDING"** et **"STREET"** : Adresse du restaurant.
   - **"ZIPCODE"** : Code postal.
   - **"CUISINE DESCRIPTION"** et **"GRADE"** : Confirme la cuisine et la note.

3. **"size": 100** : Retourne jusqu'à 100 résultats. Ce nombre peut être ajusté selon le besoin.

![requete](./img/q7.png)

Aucun restaurant ne correspond aux critères de recherche. L'absence de résultats peut signifier plusieurs choses :

- **Aucun restaurant chinois avec une note A** n'a été enregistré à Brooklyn dans cet index particulier. Cela peut être dû à un manque de données pour cette combinaison spécifique dans l'index "nyc_restaurants".
- **Problème potentiel de données** : Il est possible que les informations ne soient pas complètement mises à jour ou que la nomenclature soit incorrecte dans certains champs (par exemple, des variations dans les noms des cuisines ou dans la façon dont le borough est codé).

  - Q8 : What is the address of the restaurant LADUREE?
    IMAGES :

  - requete ./img/q8.png

    Pour obtenir l'adresse du restaurant **LADUREE**, voici la requête Elasticsearch appropriée pour Kibana DevTools :

```json
GET nyc_restaurants/_search
{
  "query": {
    "match": {
      "DBA": "LADUREE"
    }
  },
  "_source": ["DBA", "BUILDING", "STREET", "ZIPCODE", "BORO"],
  "size": 1
}
```

### la requête :

1. **"query": { "match": { "DBA": "LADUREE" } }** : Utilisation d’une requête `match` pour rechercher le nom "LADUREE" dans le champ `DBA` (nom commercial).
2. **"\_source": [...]** : Limitation des champs retournés aux informations d’adresse essentielles :
   - **"DBA"** : Nom commercial (pour confirmation),
   - **"BUILDING"** et **"STREET"** : Numéro et rue de l’adresse,
   - **"ZIPCODE"** : Code postal,
   - **"BORO"** : Arrondissement (borough) du restaurant.
3. **"size": 1** : Nous limitons le retour à un seul document, car nous ne cherchons qu’une seule occurrence pour "LADUREE".

![requete](./img/q8.png)

Le résultat montre qu’un restaurant **Laduree** est situé au **20 Hudson Yards, Manhattan, New York, 10001**.

- Q9 : What cuisine is most affected by the violation "Hot food item not held at or above 140º F"?

```json
GET nyc_restaurants/_search
{
  "size": 0,
  "query": {
    "match": {
      "VIOLATION DESCRIPTION": "Hot food item not held at or above 140º F"
    }
  },
  "aggs": {
    "most_affected_cuisine": {
      "terms": {
        "field": "CUISINE DESCRIPTION",
        "size": 1,
        "order": {
          "_count": "desc"
        }
      }
    }
  }
}
```

### La requête :

1. **"size": 0** : Nous n'avons pas besoin des documents individuels, seulement des résultats d'agrégation.
2. **"query"** : Filtre pour sélectionner les documents qui contiennent la description de violation "Hot food item not held at or above 140º F".
   - **"match": { "VIOLATION DESCRIPTION": "Hot food item not held at or above 140º F" }** : Utilise une requête `match` pour rechercher la description exacte de la violation.
3. **"aggs"** : Définition de l'agrégation pour identifier le type de cuisine le plus fréquemment associé à cette violation.
   - **"most_affected_cuisine"** : Nom de l'agrégation pour collecter les informations.
   - **"terms"** : Type d'agrégation `terms` qui regroupe par cuisine.
     - **"field": "CUISINE DESCRIPTION"** : Champ utilisé pour identifier les types de cuisine.
     - **"size": 1** : Limite le retour au type de cuisine le plus fréquent pour cette violation.
     - **"order": { "\_count": "desc" }** : Trie par ordre décroissant pour obtenir le type de cuisine le plus touché en premier.

![requete](./img/q9.png)

Le résultat de la requête montre que la cuisine **américaine** est la plus affectée par la violation **"Hot food item not held at or above 140º F"** dans les données des restaurants de New York. Ce chiffre élevé de 39,570 occurrences pourrait indiquer une vigilance accrue nécessaire dans la gestion de la température des plats dans les restaurants de cuisine américaine, par rapport à d'autres types de cuisines.

1. **Résumé de la requête** :

   - `"took": 390` : La requête a pris 390 millisecondes pour s'exécuter.
   - `"timed_out": false` : La requête s’est terminée sans délai d’attente.
   - `_shards` : La requête a été exécutée sans échec sur un seul fragment, confirmant que tous les résultats sont disponibles.

2. **Résultats de la recherche (hits)** :

   - `"total": { "value": 10000, "relation": "gte" }` : L’index contient au moins 10,000 documents correspondant à cette violation.
   - `"max_score": null` et `"hits": []` : Aucun document individuel n'est retourné, car la requête a été configurée pour ne retourner que les agrégations.

3. **Agrégation "most_affected_cuisine"** :
   - **"doc_count_error_upper_bound": 0** : Il n’y a pas d'erreur dans le comptage, ce qui signifie que les résultats sont exacts.
   - **"sum_other_doc_count": 205191** : Le nombre total de documents associés à d'autres types de cuisines affectés par cette violation s'élève à 205,191, montrant que de nombreuses autres cuisines sont également concernées.
   - **"buckets"** : Contient les résultats classés des cuisines les plus affectées.
     - **"key": "American"** : La cuisine américaine est la plus touchée par cette violation.
     - **"doc_count": 39570** : La violation **"Hot food item not held at or above 140º F"** a été enregistrée 39,570 fois dans des restaurants de cuisine américaine, ce qui en fait la cuisine la plus affectée par cette infraction.

- Q10 : What are the most common violations (Top 5)?

```json
GET nyc_restaurants/_search
{
  "size": 0,
  "aggs": {
    "top_violations": {
      "terms": {
        "field": "VIOLATION CODE",
        "size": 5
      },
      "aggs": {
        "violation_description": {
          "top_hits": {
            "_source": {
              "includes": ["VIOLATION DESCRIPTION"]
            },
            "size": 1
          }
        }
      }
    }
  }
}
```

- **"size": 0** : Nous définissons cette valeur sur zéro car nous ne nous intéressons qu'aux résultats de l'agrégation, pas aux documents individuels.
- **Agrégation sur `VIOLATION CODE`** :
  - **"field": "VIOLATION CODE"** : regroupe les documents en fonction des codes de violation.
  - **"size": 5** : limite l'agrégation aux 5 codes de violation les plus courants.
- **Sous-agrégation `violation_description`** :
  - **"top_hits"** : récupère les principaux documents pour chaque compartiment.
  - **"\_source": { "includes": ["VIOLATION DESCRIPTION"] }** : Inclut uniquement le champ `VIOLATION DESCRIPTION` dans les résultats.
  - **"size": 1** : Récupère un document par code de violation, en supposant que la description est cohérente pour chaque code.

![requete](./img/q10.png)

La requête identifie avec succès les cinq violations les plus courantes du code de la santé dans les restaurants de New York, offrant ainsi des informations précieuses sur les domaines qui nécessitent une attention immédiate pour protéger la santé publique. En tenant compte de la précision et du rappel, nous garantissons que les résultats sont exacts et complets, répondant directement à la question initiale.

- Q11 : What is the most popular restaurant chain?

![requete](./img/q11_error.png)  
![requete](./img/q11_correct.png)

### Étape 1 : Mettre à jour le mappage pour inclure « DBA.keyword »

1. **Créez un nouvel index avec le mappage mis à jour**. Cet index aura le champ « DBA » mis à jour pour inclure un sous-champ « key » pour les agrégations.

   ```json
   PUT nyc_restaurants_v2
   {
     "mappings": {
       "properties": {
         "@timestamp": {
           "type": "date"
         },
         "ACTION": {
           "type": "text"
         },
         "BBL": {
           "type": "long"
         },
         "BIN": {
           "type": "long"
         },
         "BORO": {
           "type": "keyword"
         },
         "BUILDING": {
           "type": "keyword"
         },
         "CAMIS": {
           "type": "long"
         },
         "CRITICAL FLAG": {
           "type": "keyword"
         },
         "CUISINE DESCRIPTION": {
           "type": "keyword"
         },
         "Census Tract": {
           "type": "long"
         },
         "Community Board": {
           "type": "long"
         },
         "Council District": {
           "type": "long"
         },
         "DBA": {
           "type": "text",
           "fields": {
             "keyword": {
               "type": "keyword",
               "ignore_above": 256
             }
           }
         },
         "GRADE": {
           "type": "keyword"
         },
         "GRADE DATE": {
           "type": "date",
           "format": "MM/dd/yyyy"
         },
         "INSPECTION DATE": {
           "type": "date",
           "format": "MM/dd/yyyy"
         },
         "INSPECTION TYPE": {
           "type": "keyword"
         },
         "Latitude": {
           "type": "double"
         },
         "Longitude": {
           "type": "double"
         },
         "NTA": {
           "type": "keyword"
         },
         "PHONE": {
           "type": "keyword"
         },
         "RECORD DATE": {
           "type": "date",
           "format": "MM/dd/yyyy"
         },
         "SCORE": {
           "type": "long"
         },
         "STREET": {
           "type": "keyword"
         },
         "VIOLATION CODE": {
           "type": "keyword"
         },
         "VIOLATION DESCRIPTION": {
           "type": "text"
         },
         "ZIPCODE": {
           "type": "keyword"
         },
         "location": {
           "type": "geo_point"
         }
       }
     }
   }
   ```

2. **Réindexez les données de l'ancien index (`nyc_restaurants`) vers le nouvel index (`nyc_restaurants_v2`)** :

   ```json
   POST _reindex
   {
     "source": {
       "index": "nyc_restaurants"
     },
     "dest": {
       "index": "nyc_restaurants_v2"
     }
   }
   ```

3. **Supprimer l'ancien index**

   ```json
   DELETE nyc_restaurants
   ```

4. **Renommer l'index**

   ```json
   POST /_aliases
   {
     "actions": [
       { "remove": { "index": "nyc_restaurants_v2", "alias": "nyc_restaurants" } },
       { "add": { "index": "nyc_restaurants_v2", "alias": "nyc_restaurants" } }
     ]
   }
   ```

### Step 2: Exécution de la requête d'agrégation pour trouver la chaîne de restaurants la plus populaire

Maintenant que nous avons réindexé avec le mappage correct, nous pouvons utiliser la requête suivante pour trouver la chaîne de restaurants la plus populaire en comptant les occurrences uniques de « DBA.keyword »:

```json
GET nyc_restaurants/_search
{
  "size": 0,
  "aggs": {
    "popular_restaurants": {
      "terms": {
        "field": "DBA.keyword",
        "size": 1
      },
      "aggs": {
        "unique_locations": {
          "cardinality": {
            "field": "CAMIS"
          }
        }
      }
    }
  }
}
```

1. **Chaîne la plus populaire par emplacements uniques** : avec « 366 » emplacements uniques, « DUNKIN » est la chaîne de restaurants la plus populaire de l'ensemble de données.
2. **Fréquence des inspections ou des enregistrements** : Le « doc_count » de « 3193 » suggère que les sites Dunkin ont eu plusieurs enregistrements ou inspections dans l'ensemble de données, ce qui reflète la grande présence de la chaîne à New York.

## Création du Dashboard Kibana

1. **Ajoutez des filtres** sur le type de cuisine, le quartier, et le grade pour affiner les résultats.
2. **Création de visualisations** :

   - Utilisez des cartes pour afficher la répartition géographique des types de cuisine.
   - Ajoutez des graphiques pour les violations les plus fréquentes et les grades par quartier.

   ![Carte des Types de Cuisine](./img/Cuisine-type-Neighborhood-Rank_map.png)

**Export de la visualisation Kibana** :

- [Visualisation Kibana](./data/export/Cuisinetype-Neighborhood-Rank-MAP-VISUALISATION.ndjson)

👤 **Auteur** : OTTO Dieu-Puissant Cyprien
