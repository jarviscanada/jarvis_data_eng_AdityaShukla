# Hadoop Project
# Hadoop & Hive Project on Google Cloud Dataproc

## Table of Contents
- [Introduction](#introduction)  
- [Purpose of this Project](#purpose-of-this-project)  
- [Learning and Evaluation](#learning-and-evaluation)  
- [Hadoop Cluster, Tools, and the Hive Project](#hadoop-cluster-tools-and-the-hive-project)  
  - [Hadoop Cluster](#hadoop-cluster)  
  - [Cluster Architecture Diagram](#cluster-architecture-diagram)  
  - [Hardware Specifications](#hardware-specifications)  
  - [Cluster Architecture (Master Node, Worker Nodes)](#cluster-architecture-master-node-worker-nodes)  
  - [Core Components from the Hadoop Ecosystem](#core-components-from-the-hadoop-ecosystem)  
  - [Big Data Tools](#big-data-tools)  
- [Hive Project](#hive-project)  
  - [Data Ingestion and Schema Design](#data-ingestion-and-schema-design)  
  - [Debugging and SerDe Challenges](#debugging-and-serde-challenges)  
  - [Performance Tuning in Hive](#performance-tuning-in-hive)  
  - [Parquet Conversion and Compression Benefits](#parquet-conversion-and-compression-benefits)  
  - [Execution Engine Comparisons](#execution-engine-comparisons)  
- [Zeppelin Notebook](#zeppelin-notebook)  
- [Improvements](#improvements)  
  - [Key Improvements Implemented](#key-improvements-implemented)  
  - [Future Improvements](#future-improvements)  

---

## Introduction
This project explores **Apache Hadoop and Hive** on a cloud-based Hadoop cluster provisioned via **Google Cloud Dataproc**.  
It demonstrates the end-to-end pipeline for ingesting **World Development Indicator (WDI)** data, querying with HiveQL, debugging parsing challenges, and tuning for performance using different file formats, partitioning, and execution engines.  

The work highlights both the technical challenges of working with large datasets and the optimizations required to make queries efficient in distributed systems.

---

## Purpose of this Project
The goal of this project was to:

- Understand Hadoops distributed storage (**HDFS**) and processing (**YARN, Tez, MapReduce, Spark**).  
- Gain practical experience provisioning and configuring a **3-node cluster** on GCP Dataproc.  
- Load and query large **CSV datasets (World Bank WDI)**.  
- Evaluate query performance under different storage formats (**CSV vs Parquet**).  
- Experiment with **partitioning, SerDe libraries, and execution engines** (MapReduce, Tez, SparkSQL).  
- Document improvements and lessons learned for future scalability.  

---

## Learning and Evaluation
Key learnings included:

- **CSV in HDFS vs Google Storage (GS):** Queries on HDFS-backed tables were much faster than GS-backed tables.  
- **Parsing challenges:** Columns like `indicator_code` were malformed. Debugging with raw-text tables led to adopting **OpenCSVSerde**, improving correctness but adding overhead.  
- **Partitioning:** Adding **year-based partitions** reduced query scans from ~90s to just **2s** for filtered queries.  
- **Parquet conversion:** Reduced storage from **~4.7 GB (CSV)** to **~263 MB (Parquet)**, enabling column pruning and faster queries.  
- **Execution time comparison:**  
  - CSV (HDFS): ~1m 20s  
  - Parquet: ~21s  
  - Partitioned Parquet: ~2s (on targeted queries).  
- **Execution engines:** Switching from **MapReduce ? Tez** improved runtimes by reducing overhead. **SparkSQL** was also effective for window functions.  

---

## Hadoop Cluster, Tools, and the Hive Project

### Hadoop Cluster
The project was executed on a **3-node Hadoop cluster** provisioned with Google Cloud Dataproc.

### Cluster Architecture Diagram
*(Insert diagram here if available)*

### Hardware Specifications
- **Region:** us-east1  
- **Zone:** us-east1-d  
- **Image:** Dataproc 2.2.64 (Debian 12)  
- **Master Node:** n4-standard-4 (4 vCPUs, 16 GB memory, 100GB disk)  
- **Worker Nodes:** 2 × n4-standard-4 (4 vCPUs, 16 GB memory, 100GB disk each)  
- **GPUs:** None  
- **Local SSDs:** None  
- **Autoscaling:** Disabled  
- **Optional Components:** Zeppelin  

### Cluster Architecture (Master Node, Worker Nodes)
- **Master Node:** Managed HDFS NameNode metadata, YARN scheduling, HiveServer2, Zeppelin Notebook, and query orchestration.  
- **Worker Nodes:** Hosted HDFS DataNodes and executed distributed compute tasks (MapReduce, Tez, Spark).  

### Core Components from the Hadoop Ecosystem
- **HDFS:** Distributed storage with replication and fault tolerance.  
- **YARN:** Cluster-wide resource management.  
- **MapReduce:** Baseline execution engine for batch queries.  
- **Tez:** DAG-based execution, faster than MapReduce.  
- **Hive:** SQL-like query interface, integrated with Hive Metastore.  
- **Zeppelin:** Interactive notebook for HiveQL, SparkSQL, and visualization.  

### Big Data Tools
- MapReduce  
- Tez  
- SparkSQL  
- HiveQL  
- Zeppelin  

---

## Hive Project

### Data Ingestion and Schema Design
- Created initial **external tables (wdi_gs_debug)** on raw CSV in Google Storage.  
- Transitioned to **HDFS tables (wdi_csv_text)** for better performance.  
- Adopted **OpenCSVSerde** to handle quoted fields correctly.  

### Debugging and SerDe Challenges
- Identified malformed columns (e.g., `indicator_code`).  
- Used text-only debug tables to inspect raw rows.  
- OpenCSVSerde fixed parsing but slowed queries.  

### Performance Tuning in Hive
- **Partitioning by year** reduced scan size and runtime (**95s ? 2s**).  
- **Format conversion to Parquet** provided compression and faster queries.  
- Tested **execution engines**: MapReduce, Tez, SparkSQL.  

### Parquet Conversion and Compression Benefits
- **File size reduction:**  
  - CSV HDFS: ~4.7 GB  
  - Parquet HDFS: ~263 MB (~18x smaller).  
- **Query performance:**  
  - CSV: ~1m 20s  
  - Parquet: ~21s  
  - Partitioned Parquet: ~2s  

### Execution Engine Comparisons
- **MapReduce:** Reliable, high latency.  
- **Tez:** Faster DAG execution, reduced job overhead.  
- **SparkSQL:** Excellent for advanced queries (e.g., window functions).  

---

## Zeppelin Notebook
- [Hive JDBC Zeppelin Notebook](hive/Hive%20jdbc.zpln)  
- ![Hive JDBC Screenshot](hive/Hive%20jdbc%20screenshot.png)  

---

## Improvements

### Key Improvements Implemented
- Migrated storage **CSV (GS) ? CSV (HDFS) ? Parquet (HDFS)**.  
- Added **year-based partitioning** for efficient queries.  
- Used **Tez and SparkSQL** for faster execution.  
- Reduced dataset size from **~4.7 GB ? ~263 MB**.  

### Future Improvements
- Enable **autoscaling** for larger workloads.  
- Explore **bucketed tables** for faster joins.  
- Integrate **LLAP (Low Latency Analytical Processing)** with Hive.  
- Extend pipeline with **Spark MLlib** for advanced analytics on WDI data.
