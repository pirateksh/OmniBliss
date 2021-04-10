from django.urls import path
from . import views

urlpatterns = [
    path('', views.measure, name="measure"),
    path('activity_todo/', views.activity_todo, name="activity_todo"),
]

