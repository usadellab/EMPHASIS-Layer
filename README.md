# EMPHASIS-Layer

Find details on the [EMPHASIS project here](https://emphasis.plant-phenotyping.eu/EMPHASIS_mission).

This repository holds the resources and code implementing the software suite EMPHASIS-Layer (EL) developed to standardize and integrate high throughput plant phenotyping data from participating and registered research institutes (RIs).

## Software tools

The EMPHASIS-Layer will be implemented using code generators that consume data model definitions and automatically create two interfaces exposing standard access functions to these data models. The [tools are found here](https://sciencedb.github.io/) and in [this GitHub account](https://github.com/ScienceDb/).

## Standardization

Significant efforts have been made to standardize data produced in plant breeding research projects. Data formats are defined as _models_ in the [Breeding API (BrAPI)](https://brapi.docs.apiary.io/). We used BrAPI version two and exctracted the data models for the EMPHASIS-Layer from there. Furthermore we use the "[Minimal Information About Plant Phenotyping Experiments (MIAPPE)](https://www.miappe.org/)" to store and standardize additional information, especially meta-data informing about methods and published resources associated with stored records.

### Data models

The resulting data models are defined using a [domain specific language](https://sciencedb.github.io/setup_data_scheme.html) encoded in [JSON](https://www.json.org/json-de.html). You can find the definitions in this project's [`data_model_definitions`](https://github.com/usadellab/EMPHASIS-Layer/tree/master/data_model_definitions) folder. A graphical [UML](https://en.wikipedia.org/wiki/Unified_Modeling_Language)-like diagram of all models and their asociations can be found [here](https://github.com/usadellab/EMPHASIS-Layer/blob/master/documentation/BV2_EL-models.pdf).
