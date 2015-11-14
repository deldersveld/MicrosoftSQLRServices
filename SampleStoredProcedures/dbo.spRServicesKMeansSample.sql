CREATE PROCEDURE dbo.spRServicesKMeansSample AS
BEGIN
	execute sp_execute_external_script
		@language = N'R',
		@script = N'clusterCount <- 4;
			df <- data.frame(InputDataSet);
			clusterFeatures <- data.frame(df$YearlyIncome, df$TotalChildren, df$HouseOwnerFlag);
			clusterResult <- kmeans(clusterFeatures, centers=clusterCount, iter.max=8)$cluster;
			OutputDataSet <- data.frame(df, clusterResult);',
		@input_data_1 = N'SELECT TOP 100 CustomerKey, 
							YearlyIncome, 
							TotalChildren, 
							CAST(HouseOwnerFlag as varchar(1)) AS HouseOwnerFlag 
						FROM dbo.DimCustomer;'
	WITH RESULT SETS ((
		CustomerKey int NOT NULL,
		YearlyIncome float NOT NULL,
		TotalChildren int NOT NULL,
		HouseOwnerFlag varchar(1) NOT NULL,
		ClusterResult int NOT NULL
	));
END
