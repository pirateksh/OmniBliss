from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from hrvanalysis import get_time_domain_features, get_frequency_domain_features, \
    get_sampen, get_poincare_plot_features

FEAT = []
for _ in range(0, 18):
    FEAT.append([0])


@api_view(['Post'])
@permission_classes([IsAuthenticated])
def measure(request):
    hr = request.data.get('hr', None) # String with space separated Heart-Rates
    hr = hr.split(" ")
    sample_size = len(hr)
    response = {}
    if hr and sample_size != 100:
        nn_intervals_list = hr
        nn_intervals_list = [float(i) for i in nn_intervals_list]
        nn_intervals_list = [60000 / i for i in nn_intervals_list]

        time_domain_features = get_time_domain_features(nn_intervals_list)
        frq_domain_features = get_frequency_domain_features(nn_intervals_list)
        poincare_plot_features = get_poincare_plot_features(nn_intervals_list)
        sampen_dict = get_sampen(nn_intervals_list)

        FEAT[0][0] = time_domain_features.get('mean_nni')
        FEAT[1][0] = time_domain_features.get('median_nni')
        FEAT[2][0] = time_domain_features.get('sdnn')
        FEAT[3][0] = time_domain_features.get('rmssd')
        FEAT[4][0] = time_domain_features.get('sdsd')
        FEAT[5][0] = time_domain_features.get('mean_hr')
        FEAT[6][0] = time_domain_features.get('pnni_50')
        FEAT[7][0] = poincare_plot_features.get('sd1')
        FEAT[8][0] = poincare_plot_features.get('sd2')
        FEAT[9][0] = frq_domain_features.get('vlf')
        FEAT[10][0] = frq_domain_features.get('lf')
        FEAT[11][0] = frq_domain_features.get('lfnu')
        FEAT[12][0] = frq_domain_features.get('hf')
        FEAT[13][0] = frq_domain_features.get('hfnu')
        FEAT[14][0] = frq_domain_features.get('total_power')
        FEAT[15][0] = frq_domain_features.get('lf_hf_ratio')
        FEAT[16][0] = 1.0 / FEAT[15][0]
        FEAT[17][0] = sampen_dict.get('sampen')

        row = []
        for __ in range(0, 18):
            row.append(FEAT[__][0])

        import pickle
        loaded_model = pickle.load(open("dt_stress_classifier.sav", 'rb'))
        result = loaded_model.predict(row)

        # dict = {
        #     'MEAN_RR': FEAT[0],
        #     'MEDIAN_RR': FEAT[1],
        #     'SDRR': FEAT[2],
        #     'RMSSD': FEAT[3],
        #     'SDSD': FEAT[4],
        #     'HR': FEAT[5],
        #     'pNN50': FEAT[6],
        #     'SD1': FEAT[7],
        #     'SD2': FEAT[8],
        #     'VLF': FEAT[9],
        #     'LF': FEAT[10],
        #     'LF_NU': FEAT[11],
        #     'HF': FEAT[12],
        #     'HF_NU': FEAT[13],
        #     'TP': FEAT[14],
        #     'LF_HF': FEAT[15],
        #     'HF_LF': FEAT[16],
        #     'sampen': FEAT[17]
        # }

        # TODO:
        #  FEAT is a List of Lists. Feat[i][0] represents the value of ith feature, 0<=i<=17
        #  Model will consume this list for Stress Detection.
        if result == 0:
            response['status'] = "No Stress"
        else:
            response['status'] = "Stressed"
        return Response(response)
    else:
        response['msg'] = "Heart-Rate Data does not contain 100 Samples"
        Response(response)

