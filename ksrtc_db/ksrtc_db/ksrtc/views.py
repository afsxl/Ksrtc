import base64
from rest_framework.response import Response
from rest_framework.decorators import api_view
from institution.models import *
from user.models import *
from .models import *
from depot.models import *


@api_view(["POST"])
def ksrtcGetInstitutions(request):
    institutions = []
    rows = Institutions.objects.filter().all()
    for i in rows:
        institutions.append(
            {
                "institution": i.institution,
                "place": i.place,
                "district": i.district,
                "id": i.id,
            }
        )
    return Response(
        {
            "institutions": institutions,
        }
    )


@api_view(["POST"])
def ksrtcGetInstitution(request):
    data = request.data
    id = data["id"]
    courses = list(
        Courses.objects.filter(
            institutionId=id,
        ).values_list(
            "course",
            flat=True,
        )
    )
    return Response(
        {
            "courses": courses,
        }
    )


@api_view(["POST"])
def ksrtcGetPlaces(request):
    data = request.data
    district = data["district"]
    places = Places.objects.filter(
        district=district,
    ).values_list(
        "place",
        flat=True,
    )
    places = list(places)
    return Response(
        {
            "places": places,
        }
    )


@api_view(["POST"])
def ksrtcAddInstitution(request):
    data = request.data
    district = data["district"]
    place = data["place"]
    institution = data["institution"]
    institution = institution.upper()
    if Institutions.objects.filter(
        institution=institution,
        district=district,
        place=place,
    ).exists():
        return Response(
            {
                "status": False,
            }
        )
    Institutions.objects.create(
        institution=institution,
        district=district,
        place=place,
    )
    return Response(
        {
            "status": True,
        }
    )


@api_view(["POST"])
def ksrtcGetCompletedApplications(request):
    applicationRows = Concession.objects.filter().all()
    applications = []
    for i in applicationRows:
        photo = base64.b64encode(
            i.photo.read(),
        ).decode(
            "utf-8",
        )
        applications.append(
            {
                "name": i.name,
                "aadhar": i.aadhar,
                "photo": photo,
                "id": i.id,
            }
        )
    return Response(
        {
            "applications": applications,
        }
    )


@api_view(["POST"])
def ksrtcGetCompletedApplication(request):
    data = request.data
    id = data["id"]
    row = Concession.objects.get(
        id=id,
    )
    idCard = base64.b64encode(
        row.idCard.read(),
    ).decode(
        "utf-8",
    )
    aadharFront = base64.b64encode(
        row.aadharFront.read(),
    ).decode(
        "utf-8",
    )
    aadharBack = base64.b64encode(
        row.aadharBack.read(),
    ).decode(
        "utf-8",
    )
    application = {
        "idCard": idCard,
        "age": row.age,
        "aadharFront": aadharFront,
        "aadharBack": aadharBack,
        "startPoint": row.startPoint,
        "endPoint": row.endPoint,
        "rate": row.rate,
        "district": row.district,
        "place": row.place,
        "institution": row.institution,
        "course": row.course,
        "cost": row.cost,
        "homeDistrict": row.homeDistrict,
        "depot": row.depot,
    }
    return Response(
        {
            "application": application,
        }
    )


@api_view(["POST"])
def ksrtcDeleteInstitution(request):
    data = request.data
    id = data["id"]
    Institutions.objects.filter(
        id=id,
    ).delete()
    Courses.objects.filter(
        institutionId=id,
    ).delete()
    return Response()


@api_view(["POST"])
def ksrtcGetDepots(request):
    depots = []
    rows = Depots.objects.all()
    for i in rows:
        depots.append(
            {
                "depot": i.depot,
                "district": i.district,
                "password": i.password,
                "id": i.id,
            }
        )
    return Response(
        {
            "depots": depots,
        }
    )


@api_view(["POST"])
def ksrtcDeleteDepot(request):
    data = request.data
    id = data["id"]
    Depots.objects.filter(
        id=id,
    ).delete()
    return Response()


@api_view(["POST"])
def ksrtcAddDepot(request):
    data = request.data
    district = data["district"]
    depot = data["depot"]
    password = data["password"]
    if Depots.objects.filter(
        district=district,
        depot=depot,
    ).exists():
        return Response(
            {
                "status": False,
            }
        )
    Depots.objects.create(
        district=district,
        depot=depot,
        password=password,
    )
    return Response(
        {
            "status": True,
        }
    )
