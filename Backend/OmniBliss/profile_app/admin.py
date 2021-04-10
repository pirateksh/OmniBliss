from django.contrib import admin
from .models import Profile, Occupation


class ProfileAdmin(admin.ModelAdmin):
    model = Profile
    list_display = ['user', 'age', 'gender', 'phone', 'occupation']


class OccupationAdmin(admin.ModelAdmin):
    model = Occupation
    list_display = ['id', 'title']


admin.site.register(Profile, ProfileAdmin)
admin.site.register(Occupation, OccupationAdmin)
