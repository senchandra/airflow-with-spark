from pyspark import SparkContext
logFilepath = "/tmp/wordcount.txt"
sc = SparkContext("spark://127.0.1.1:7077", "wordcount")
logData = sc.textFile(logFilepath).cache()
numAs = logData.filter(lambda s: 'a' in s).count()
numBs = logData.filter(lambda s: 'b' in s).count()
print("Lines with a: %i, lines with b: %i" % (numAs, numBs))
