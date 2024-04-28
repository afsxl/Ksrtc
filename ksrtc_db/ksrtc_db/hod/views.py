import base64
from rest_framework.response import Response
from rest_framework.decorators import api_view
from institution.models import *
from user.models import *

# Create your views here.


@api_view(["POST"])
def hodCheckLogin(request):
    data = request.data
    id = data["id"]
    password = data["password"]
    if Courses.objects.filter(
        id=id,
        password=password,
    ).exists():
        return Response(
            {
                "status": True,
            }
        )
    return Response(
        {
            "status": False,
        }
    )


@api_view(["POST"])
def hodGetPlaces(request):
    data = request.data
    district = data["district"]
    places = Institutions.objects.filter(
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
def hodGetInstitutions(request):
    data = request.data
    district = data["district"]
    place = data["place"]
    institutions = Institutions.objects.filter(
        district=district,
        place=place,
    ).values_list(
        "institution",
        flat=True,
    )
    institutions = list(institutions)
    return Response(
        {
            "institutions": institutions,
        }
    )


@api_view(["POST"])
def hodGetCourses(request):
    data = request.data
    district = data["district"]
    place = data["place"]
    institution = data["institution"]
    id = Institutions.objects.get(
        district=district,
        place=place,
        institution=institution,
    ).id
    courses = Courses.objects.filter(institutionId=id).values_list(
        "course",
        flat=True,
    )
    return Response(
        {
            "courses": courses,
        }
    )


@api_view(["POST"])
def hodSignin(request):
    data = request.data
    district = data["district"]
    place = data["place"]
    institution = data["institution"]
    course = data["course"]
    password = data["password"]
    institutionId = Institutions.objects.get(
        district=district,
        place=place,
        institution=institution,
    ).id
    id = Courses.objects.get(
        institutionId=institutionId,
        course=course,
    ).id
    if Courses.objects.filter(
        id=id,
        password=password,
    ).exists():
        return Response(
            {
                "id": id,
                "status": True,
            }
        )
    return Response(
        {
            "status": False,
        }
    )


@api_view(["POST"])
def hodGetProfile(request):
    data = request.data
    id = data["id"]
    course = Courses.objects.get(
        id=id,
    ).course
    institutionId = Courses.objects.get(
        id=id,
    ).institutionId
    institution = Institutions.objects.get(
        id=institutionId,
    ).institution
    district = Institutions.objects.get(
        id=institutionId,
    ).district
    place = Institutions.objects.get(
        id=institutionId,
    ).place
    profile = {
        "institution": institution,
        "district": district,
        "place": place,
        "course": course,
    }
    return Response(
        {
            "profile": profile,
        }
    )


@api_view(["POST"])
def hodChangePassword(request):
    data = request.data
    id = data["id"]
    password = data["password"]
    newPassword = data["newPassword"]
    if Courses.objects.filter(
        id=id,
        password=password,
    ).exists():
        Courses.objects.filter(
            id=id,
        ).update(
            password=newPassword,
        )
        return Response(
            {
                "status": True,
            }
        )
    return Response(
        {
            "status": False,
        }
    )


@api_view(["POST"])
def hodGetApplications(request):
    data = request.data
    id = data["id"]
    course = Courses.objects.get(
        id=id,
    ).course
    institutionId = Courses.objects.get(
        id=id,
    ).institutionId
    institution = Institutions.objects.get(
        id=institutionId,
    ).institution
    district = Institutions.objects.get(
        id=institutionId,
    ).district
    place = Institutions.objects.get(
        id=institutionId,
    ).place
    applicationRows = ConcessionForm.objects.filter(
        institution=institution,
        district=district,
        place=place,
        course=course,
        hodApproval=0,
    ).all()
    applications = []
    for i in applicationRows:
        photo = base64.b64encode(i.photo.read()).decode("utf-8")
        applications.append(
            {
                "name": i.name,
                "aadhar": i.aadhar,
                "photo": photo,
            }
        )
    return Response(
        {
            "applications": applications,
        }
    )


@api_view(["POST"])
def hodGetApplication(request):
    data = request.data
    aadhar = data["aadhar"]
    row = ConcessionForm.objects.get(
        aadhar=aadhar,
    )
    idCard = base64.b64encode(row.idCard.read()).decode("utf-8")
    aadharFront = base64.b64encode(row.aadharFront.read()).decode("utf-8")
    aadharBack = base64.b64encode(row.aadharBack.read()).decode("utf-8")
    application = {
        "idCard": idCard,
        "age": row.age,
        "aadharFront": aadharFront,
        "aadharBack": aadharBack,
        "startPoint": row.startPoint,
        "endPoint": row.endPoint,
        "rate": row.rate,
        "homeDistrict": row.homeDistrict,
        "depot": row.depot,
        "district": row.district,
        "place": row.place,
        "institution": row.institution,
        "course": row.course,
    }
    return Response(
        {
            "application": application,
        }
    )


@api_view(["POST"])
def hodRejectApplication(request):
    data = request.data
    aadhar = data["aadhar"]
    ConcessionForm.objects.filter(
        aadhar=aadhar,
    ).update(
        hodApproval=-1,
    )
    return Response()


@api_view(["POST"])
def hodApproveApplication(request):
    data = request.data
    aadhar = data["aadhar"]
    ConcessionForm.objects.filter(
        aadhar=aadhar,
    ).update(
        hodApproval=1,
    )
    return Response()
