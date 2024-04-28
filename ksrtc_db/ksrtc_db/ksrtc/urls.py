from django.urls import path
from . import views

urlpatterns = [
    path("ksrtcGetInstitutions", views.ksrtcGetInstitutions),
    path("ksrtcGetInstitution", views.ksrtcGetInstitution),
    path("ksrtcGetPlaces", views.ksrtcGetPlaces),
    path("ksrtcAddInstitution", views.ksrtcAddInstitution),
    path("ksrtcGetCompletedApplications", views.ksrtcGetCompletedApplications),
    path("ksrtcGetCompletedApplication", views.ksrtcGetCompletedApplication),
    path("ksrtcDeleteInstitution", views.ksrtcDeleteInstitution),
    path("ksrtcGetDepots", views.ksrtcGetDepots),
    path("ksrtcDeleteDepot", views.ksrtcDeleteDepot),
    path("ksrtcAddDepot", views.ksrtcAddDepot),
]
