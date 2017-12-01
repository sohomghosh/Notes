//PFB Phase 2 code.(With 96% Accuracy so far)

val train_df = sqlContext.read.format("com.databricks.spark.csv").option("header","true").option("inferschema","true").load("/data/train.csv").cache
val test_df = sqlContext.read.format("com.databricks.spark.csv").option("header","true").option("inferschema","true").load("/data/test.csv").cache

//val test_df1=test_df.withColumn("target",test_df.col("id"))
//val join_df=train_df.unionAll(test_df1)
//import org.apache.spark.sql.functions.regexp_replace
//val traindata = train_df.withColumn("x37New",regexp_replace(train_df("x37"),"\\,",".")).drop("x37")

import org.apache.spark.sql.functions._
//val toInt    = udf[Int, String]( _.toInt)
val toDouble = udf[Double, String]( _.toDouble)
//val toDate =udf[String,Date](_.toDate) 

def comma(a:String):Double={
val a_cleaned = a.replaceFirst(",",".").replaceAll(",","").toDouble
return (a_cleaned)
}

val outputO_udf = udf(comma _)
//val trt = join_df.withColumn("x37_new",outputO_udf($"x37")).drop("x37")

//val //joindata1=trt.withColumn("x37_New",toDouble(trt("x37_new"))).withColumn("x108new",toDouble(trt("x108"))).withColumn("Age",toDouble(datediff(current_date(),to_d//ate(trt("x31"))))).select("x53",
//"x95","x88","x30","x42","x28","x35","x65","x62","x20","x46","x84","x11","x50","x67","x86","x52","x22","x81","x74","x71","x78","x79","x18","x40","x32","x94",
//"x99","x98","x58","x55","x91","x3","x57","x15","x92","x64","x13","x5","x73","x36","x17","x68","x60","x77","x34","x93","x9","x10","x27","x70","x23","x48","x90",
//"x75","x87","x44","x54","x29","x21","x14","x41","x2","x47","x80","x49","x24","x66","x45","x4","x26","x72","x39","x1","x100","x12","x16","x59","x51","x33","x19"//,
//"x38","x69","x25","x7","x96","x97","x85","x89","x82","target","x37_New","id","Name","Zip","x101","x102","x103","x104","x105","x106","x107","x108","x108new","Ag//e")

val train_data_temp = train_df.withColumn("x37_1", outputO_udf(train_df("x37"))).withColumn("age",round(datediff(current_date(),to_date(unix_timestamp($"x31", "yyyy-m-d").cast("timestamp")))/365)).drop("x37").drop("x31").drop("Name").drop("Zip")

val test_data_temp = test_df.withColumn("x37_1", outputO_udf(test_df("x37"))).withColumn("age",round(datediff(current_date(),to_date(unix_timestamp($"x31", "yyyy-m-d").cast("timestamp")))/365)).drop("x37").drop("x31").drop("Name").drop("Zip")

val x30 = train_data_temp.agg(max("x30")).first()(0).toString.toDouble //gives us the mean of x30 as a double
val train_missing_treated_temp = train_data_temp.na.fill(Map("x30"->x30))
//Similarly missing value treatment can be done for other variables.
val test_missing_treated_temp = test_data_temp.na.fill(Map("x30"->x30))

val x84 = train_missing_treated_temp.agg(max("x84")).first()(0).toString.toDouble //gives us the mean of x30 as a double
val train_missing_treated_temp1 = train_missing_treated_temp.na.fill(Map("x84"->x84))
//Similarly missing value treatment can be done for other variables.
val test_missing_treated_temp1 = test_missing_treated_temp.na.fill(Map("x84"->x84))

val x100 = train_missing_treated_temp.agg(max("x100")).first()(0).toString.toDouble //gives us the mean of x30 as a double
val train_missing_treated_temp2 = train_missing_treated_temp.na.fill(Map("x100"->x100))
//Similarly missing value treatment can be done for other variables.
val test_missing_treated_temp2 = test_missing_treated_temp1.na.fill(Map("x100"->x100))

val x59 = train_missing_treated_temp2.agg(max("x59")).first()(0).toString.toDouble //gives us the mean of x30 as a double
val train_missing_treated_temp3 = train_missing_treated_temp2.na.fill(Map("x59"->x59))
//Similarly missing value treatment can be done for other variables.
val test_missing_treated_temp3 = test_missing_treated_temp2.na.fill(Map("x59"->x59))

val x38 = train_missing_treated_temp3.agg(max("x38")).first()(0).toString.toDouble //gives us the mean of x30 as a double
val train_missing_treated_temp4 = train_missing_treated_temp3.na.fill(Map("x38"->x38))
//Similarly missing value treatment can be done for other variables.
val test_missing_treated_temp4 = test_missing_treated_temp3.na.fill(Map("x38"->x38))

val x69 = train_missing_treated_temp4.agg(max("x69")).first()(0).toString.toDouble //gives us the mean of x30 as a double
val train_missing_treated_temp5 = train_missing_treated_temp4.na.fill(Map("x69"->x69))
//Similarly missing value treatment can be done for other variables.
val test_missing_treated_temp5 = test_missing_treated_temp4.na.fill(Map("x69"->x69))


val train_data = train_missing_treated_temp5.na.fill(0)
val test_data = test_missing_treated_temp5.na.fill(0)

val train_data = train_data_temp.na.fill(0)
val test_data = test_data_temp.na.fill(0)

val train_data1 = train_data.drop("x26").drop("x39").drop("x100").drop("x33").drop("x4").drop("x90").drop("x19").drop("x51").drop("x67").drop("x96").drop("x80").drop("x24").drop("x82").drop("x28")
val test_data1 = test_data.drop("x26").drop("x39").drop("x100").drop("x33").drop("x4").drop("x90").drop("x19").drop("x51").drop("x67").drop("x96").drop("x80").drop("x24").drop("x82").drop("x28")


val tra_1 = train_data1.filter("target=1")

/*val tra_0 = train_data.filter("target=0")

//val sd=10000
val sd = 100
val Array(tra_00, tra_01) = tra_0.randomSplit(Array(0.28, 0.82),  seed = sd)
*/

val train_final = train_data1.unionAll(tra_1).unionAll(tra_1)

val colnames = train_final.columns diff Array("target","id")
import org.apache.spark.ml.feature.VectorAssembler

val vectorizer = new VectorAssembler().setInputCols(colnames).setOutputCol("features") 

val train = vectorizer.transform(train_final).select("target","features").withColumn("label", train_final("target").cast("Double")).drop("target")
val test = vectorizer.transform(test_data1).select("id","features").withColumnRenamed("id","ID")


/*import org.apache.spark.ml.classification.MultilayerPerceptronClassifier

// check input numbers and output numbers
val layers = Array[Int](100,4,2)

val trainer = new MultilayerPerceptronClassifier()
  
trainer.setLayers(layers)
  
trainer.setBlockSize(128)
trainer.setSeed(1234L)
trainer.setMaxIter(100)

val model = trainer.fit(train)

val predictions = model.transform(test)

predictions.groupBy("label","prediction").count().show

*/









import org.apache.spark.ml.classification.{GBTClassificationModel, GBTClassifier}
import org.apache.spark.ml.Pipeline
import org.apache.spark.ml.feature.{IndexToString, StringIndexer, VectorIndexer}
import org.apache.spark.ml.evaluation._


//Label indexing 
val labelIndexer = new StringIndexer().setInputCol("label").setOutputCol("indexedLabel").fit(train)

//feature indexer for categorical values
val featureIndexer = new VectorIndexer().setInputCol("features").setOutputCol("indexedFeatures").setMaxCategories(4)

//converting labels back to origial
val labelConverter = new IndexToString().setInputCol("prediction").setOutputCol("predictedLabel").setLabels(labelIndexer.labels)



val gbm = new GBTClassifier()
//to see the default parameters
print(gbm.explainParams)
gbm.setLabelCol("indexedLabel").setFeaturesCol("features").setMaxIter(150).setMaxDepth(4).setStepSize(0.05)
//.setImpurity("entropy").setMaxBins(30)

//Define the pipeline
val pipeline = new Pipeline().setStages(Array(labelIndexer,featureIndexer,gbm,labelConverter))

//Model
val model = pipeline.fit(train)

//Predict
val predictions = model.transform(test)

import org.apache.spark.ml.regression.DecisionTreeRegressionModel
import org.apache.spark.sql.functions._
import org.apache.spark.ml.classification.GBTClassificationModel

val aa = model.stages(2).asInstanceOf[GBTClassificationModel]
val c = aa.trees.zipWithIndex.map(x => {
val d = x._1
var e = d.asInstanceOf[DecisionTreeRegressionModel]
e.setPredictionCol("pred"+x._2)
e.transform(test).select("id","pred"+x._2)})

var a = c(0)
for(i<- 1 to c.length - 1){
a = a.unionAll(c(i))
}
var b = a.groupBy("id").sum("pred0").withColumnRenamed("sum(pred0)","sumpred").join(c(0),a.col("id") === c(0).col("id")).drop(c(0).col("id"))
var z = b.withColumn("prediction",(b.col("pred0")*0.1)+(b.col("sumpred")*0.9)).drop(b.col("sumpred")).drop(b.col("pred0"))
val prob_final = z.withColumn("probability",exp(z("prediction"))/(exp(z("prediction"))+1)).select("id","probability","prediction")

//import org.apache.spark.ml.evaluation.MulticlassClassificationEvaluator
//Select your target and prediction columns
//val predictionsAndLabels = predictions.select("ID","probability").map(x=>(x(0).toString.toInt, //x(1).asInstanceOf[Vector](1))).toDF().withColumnRenamed("_1","ID").withColumnRenamed("_2", "probability")
//Type in your target column
//val prob_final1=prob_final.select("ID").toString.toDouble
//val evaluator = new MulticlassClassificationEvaluator().setMetricName("precision").setLabelCol("prediction")
//println("Precision: " + evaluator.evaluate(prob_final))

import org.apache.spark.mllib.linalg._
import org.apache.spark.sql.functions.when
//val predictionAndLabels = predictions.select("ID","probability").map(x=>(x(0).toString.toInt, x(1).asInstanceOf[Vector](1))).toDF().withColumnRenamed("_1", //"ID").withColumnRenamed("_2", "probability")



//df.registerTempTable("prob_final")
//val cutoff = sql( percentile_disc(0.97) within group (order by probability) from df)

val pred_prob = prob_final.withColumn("Prediction", when(prob_final("probability") > 0.18, 1.0).otherwise(0.0)).select("ID","Prediction").cache()


//import com.fnmathlogic.spark.evaluator.mEvaluator0
//mEvaluator0(pred_prob,sc,sqlContext)

import com.fnmathlogic.spark.evaluator.mEvaluator2
mEvaluator2(pred_prob,sc,sqlContext)


