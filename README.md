# Introduction
The LASO Integration is a Salesforce-based solution to submit data to an LHI Endpoint for automatic form completion.

## Project Structure
The `src` folder contains a number of Salesforce metadata files for deployment to any Salesforce organization. It is divided up into three folders:

1. aura - The source for a Lightning Component placed on the Court Case record page
2. classes - Apex files used in both posting data to LHI and handling the Lightning Component
3. objects - Objects needed in using Apex and Lightning Component

## Overview of Data Structure
A `Client` may have many `Case`s, which serve as a central place to hold information about an incident. `Case`s have many `Court Case`s, which is where the LHI Endponit is called from. `Court Case`s hold legal specifics about `Petitioners Involved` and `Children Involved`, as well as the `VPO`. The `VPO` contains much of the data needed for submitting a form to the LHI Endpoint. `Court Case`s also contain `Intake`s, which hold information about the time the `Client` was admitted, as well as any `Abuser`s that are named at the time.

## Technical Workflow
In order to submit a form to LHI, an Answer File is needed in HotDocs format, submitted via a SOAP API provided by LHI.

Once data is entered, a user can click the `Submit` button on a `Court Case` record page. This starts the `AnswerFileBuilder` and tells it to send the resulting HotDocs Answer File to LHI.
The `AnswerFileBuilder` requires a connection to the LHI Endpoint, which is handled through the `CallLASO` class. The `CallLASO` class handles the implementation details of contacting the LHI Endpoint.
Data is gathered for the Answer File through the `LASOData` class, which provides a straightforward way to break the data needed for the Answer File down into whom it is related to.
LHI accepts data in HotDocs format, which requires conversion via the `hc_XmlFactory`. The `hd_XmlFactory` handles converting Salesforce data into a HotDocs format for acceptance by the LHI Endpoint.
Once the data has been gathered and converted, it is sent via the `CallLASO` class through the `ssos_*` SOAP classes. The `ssos_*` classes are Salesforce-generated Apex designed to interface with the LHI SOAP Endpoint.
After submitting the Answer File to LHI, a success or failure message is returned, and placed in the `LASO Results` object.