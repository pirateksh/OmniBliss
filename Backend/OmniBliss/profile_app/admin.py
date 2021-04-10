from django.contrib import admin
from .models import Profile, Occupation, Cluster, Activity


class ProfileAdmin(admin.ModelAdmin):
    model = Profile
    list_display = ['user', 'age', 'gender', 'occupation']


class OccupationAdmin(admin.ModelAdmin):
    model = Occupation
    list_display = ['id', 'title']


class ClusterAdmin(admin.ModelAdmin):
    model = Cluster
    list_display = ['id', 'title']


class ActivityAdmin(admin.ModelAdmin):
    model = Activity
    list_display = ['id', 'title']


admin.site.register(Profile, ProfileAdmin)
admin.site.register(Occupation, OccupationAdmin)
admin.site.register(Cluster, ClusterAdmin)
admin.site.register(Activity, ActivityAdmin)
