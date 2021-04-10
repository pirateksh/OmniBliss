from django.shortcuts import render, HttpResponse
# Create your views here.


# def stress_detection():
#     print("Stress Detection Started...")
#     from sklearn.tree import DecisionTreeClassifier  # Import Decision Tree Classifier
#     from sklearn.model_selection import train_test_split  # Import train_test_split function
#     from sklearn import metrics
#     import numpy as np
#     import pandas as pd
#     import pickle
#     print("Imported Dependencies")
#
#     # Importing Dataset
#     test = pd.read_csv('data/test.csv')
#     train = pd.read_csv('data/train.csv')
#     print("Read Data")
#     # Mapping condition
#     condition = {'no stress': 0, 'interruption': 1, 'time pressure': 2}
#     train['condition'] = train['condition'].map(condition)
#     test['condition'] = test['condition'].map(condition)
#
#     features_train = ['MEAN_RR', 'MEDIAN_RR', 'SDRR', 'RMSSD', 'SDSD', 'HR', 'pNN50', 'SD1', 'SD2', 'VLF', 'LF',
#                       'LF_NU', 'HF', 'HF_NU', 'TP', 'LF_HF', 'HF_LF', 'sampen']
#     X = train[features_train]
#     Y = train[['condition']]
#     print("Prepared Data")
#     # Split dataset into training set and test set
#     X_train, X_test, y_train, y_test = train_test_split(X, Y, test_size=0.3, random_state=1)
#     print("Splitted Data")
#     # Create Decision Tree classifer object
#     clf = DecisionTreeClassifier()
#
#     # Train Decision Tree Classifer
#     clf = clf.fit(X_train, y_train)
#
#     # Predict the response for test dataset
#     y_pred = clf.predict(X_test)
#
#     # Model Accuracy
#     print("Accuracy:", metrics.accuracy_score(y_test, y_pred))
#
#     filename = 'dt_stress_classifier.sav'
#     pickle.dump(clf, open(filename, 'wb'))
#     print("Done...")


# def cluster_users():
#     from sklearn.cluster import KMeans
#     from sklearn.decomposition import PCA
#     import pandas as pd
#     import pickle
#     print("Imported dependencies...")
#
#     customers = pd.read_csv("dataset_users.csv")
#     print("Read dateset....")
#
#     customers["Male"] = customers.Gender.apply(lambda x: 0 if x == 0 else 1)
#     customers["Female"] = customers.Gender.apply(lambda x: 0 if x == 1 else 1)
#     customers["Others"] = customers.Gender.apply(lambda x: 0 if x == 2 else 1)
#
#     X = customers.iloc[:, 1:]
#     print("Prepared dateset...")
#
#
#     pca = PCA(n_components=2).fit(X)
#     pca_2d = pca.transform(X)
#
#     kmeans = KMeans(n_clusters=4, init='k-means++', max_iter=10, n_init=10, random_state=0)
#
#     # Fit and predict
#     y_means = kmeans.fit_predict(X)
#     print("Model preprepared...")
#
#     filename = 'kmeans_user_clustering.sav'
#     pickle.dump(kmeans, open(filename, 'wb'))
#     print("File dumped...SUCCESS")


def test(request):
    """
    Made By KSHITIZ just for testing
    :param request:
    :return:
    """
    return HttpResponse("This is for Test")
