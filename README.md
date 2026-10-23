# E-Commerce Data Warehouse & Analytics Engine

Bu proje, OLAP (Online Analytical Processing) iş yükleri, çok boyutlu analizler (`multi-dimensional analysis`) ve Microsoft SQL Server kullanarak optimize edilmiş aggregation (toplulaştırma) performansını hedefleyen yüksek performanslı ilişkisel bir veri ambarıdır (`relational data warehouse`).

## Architecture & Schema 
Proje, iş boyutlarını (`business dimensions`) transactional faktörlerden ayırmak için klasik bir **Star Schema** mimarisi kullanır:
- **DimCustomer**: Müşteri demografik bilgilerini, şehirleri ve segment sınıflandırmalarını tutar.
- **DimProduct**: Ürün envanter detaylarını, kategorileri ve birim fiyatlarını tutar.
- **FactSales**: Boyutlara ait foreign key'leri, miktar (`quantity`) ve toplam ciro (`total revenue`) gibi metrikleri barındıran merkezi işlem tablosudur (`transactional fact table`).

## Performance Optimization & Indexing 
Ağır analitik sorgular ve büyük ölçekli veri taramalarıyla başa çıkmak için şu indeksleme stratejileri uygulanmıştır:
- **Non-Clustered Indexes**: İlişkisel join (birleştirme) operasyonlarını optimize etmek için foreign key kolonları (`CustomerId`, `ProductId`) üzerine kurulmuştur.
- **Non-Clustered Columnstore Index**: Batch-mode yürütme ve yüksek sıkıştırma oranları sayesinde OLAP sorgu performansını (`GROUP BY`, `SUM`, aggregations) büyük ölçüde artırmak için `FactSales` tablosu kolonlarına uygulanmıştır.

## Massive Data Generation Engine 
- Performans kıyaslaması (`performance benchmarking`) amacıyla milyonlarca satış satırını simüle etmek için cross-join ve randomize batch insertion mantığını kullanan özel bir **Stored Procedure (`GenerateBulkSales`)** içerir.

## Tech Stack 
- **Database Management System**: Microsoft SQL Server (SSMS 20)
- **Concepts**: Star Schema, OLAP Optimization, Columnstore Indexing, Stored Procedures
