from django.urls import path
from . import views

urlpatterns = [
    path("ksrtcGetApplications", views.ksrtcGetApplications),
    path("ksrtcGetApplication", views.ksrtcGetApplication),
    path("ksrtcRejectApplication", views.ksrtcRejectApplication),
    path("ksrtcApproveApplication", views.ksrtcApproveApplication),
    path("ksrtcGetInstitutions", views.ksrtcGetInstitutions),
    path("ksrtcGetInstitution", views.ksrtcGetInstitution),
    path("ksrtcGetPlaces", views.ksrtcGetPlaces),
    path("ksrtcAddInstitution", views.ksrtcAddInstitution),
    path("ksrtcGetCompletedApplications", views.ksrtcGetCompletedApplications),
    path("ksrtcGetCompletedApplication", views.ksrtcGetCompletedApplication),
    path("ksrtcDeleteInstitution", views.ksrtcDeleteInstitution),
]
