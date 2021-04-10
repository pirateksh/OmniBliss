from django.urls import path
from . import views

urlpatterns = [
    # path('measure/', views.register, name="measure"),
    path('', views.test, name="test"),
]

