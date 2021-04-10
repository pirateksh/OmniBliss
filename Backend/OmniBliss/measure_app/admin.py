from django.contrib import admin
from .models import Priority


class PriorityAdmin(admin.ModelAdmin):
    model = Priority
    list_display = ['cluster', 'activity', 'priority']


admin.site.register(Priority, PriorityAdmin)