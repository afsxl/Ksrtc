import base64
from rest_framework.response import Response
from rest_framework.decorators import api_view
from institution.models import *
from user.models import *

# Create your views here.


@api_view(["POST"])
def institutionCheckLogin(request):
    data = request.data
    id = data["id"]
    password = data["password"]
    if Institutions.objects.filter(
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
def institutionGetPlaces(request):
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
def institutionGetInstitutions(request):
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
def institutionSignin(request):
    data = request.data
    district = data["district"]
    place = data["place"]
    institution = data["institution"]
    password = data["password"]
    id = Institutions.objects.get(
        district=district,
        place=place,
        institution=institution,
    ).id
    if Institutions.objects.filter(
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
def institutionGetProfile(request):
    data = request.data
    id = data["id"]
    institution = Institutions.objects.get(id=id).institution
    district = Institutions.objects.get(id=id).district
    place = Institutions.objects.get(id=id).place
    profile = {
        "institution": institution,
        "district": district,
        "place": place,
    }
    return Response(
        {
            "profile": profile,
        }
    )


@api_view(["POST"])
def institutionChangePassword(request):
    data = request.data
    id = data["id"]
    password = data["password"]
    newPassword = data["newPassword"]
    if Institutions.objects.filter(
        id=id,
        password=password,
    ).exists():
        Institutions.objects.filter(
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
def institutionGetApplications(request):
    data = request.data
    id = data["id"]
    institution = Institutions.objects.get(
        id=id,
    ).institution
    district = Institutions.objects.get(
        id=id,
    ).district
    place = Institutions.objects.get(
        id=id,
    ).place
    applicationRows = ConcessionForm.objects.filter(
        institution=institution,
        district=district,
        place=place,
        hodApproval=1,
        institutionApproval=0,
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
def institutionGetApplication(request):
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
def institutionRejectApplication(request):
    data = request.data
    aadhar = data["aadhar"]
    ConcessionForm.objects.filter(
        aadhar=aadhar,
    ).update(
        institutionApproval=-1,
    )
    return Response()


@api_view(["POST"])
def institutionApproveApplication(request):
    data = request.data
    aadhar = data["aadhar"]
    ConcessionForm.objects.filter(
        aadhar=aadhar,
    ).update(
        institutionApproval=1,
    )
    return Response()


@api_view(["POST"])
def institutionAddCourse(request):
    data = request.data
    course = data["course"]
    password = data["password"]
    id = data["id"]
    course = course.upper()
    if Courses.objects.filter(
        course=course,
        institutionId=id,
    ).exists():
        return Response(
            {
                "status": False,
            }
        )
    Courses.objects.create(
        course=course.upper(),
        password=password,
        institutionId=id,
    )
    return Response(
        {
            "status": True,
        }
    )


@api_view(["POST"])
def institutionGetCourses(request):
    data = request.data
    id = data["id"]
    coursesRows = Courses.objects.filter(
        institutionId=id,
    ).all()
    courses = []
    for i in coursesRows:
        courses.append(
            {
                "courseId": i.id,
                "course": i.course,
                "password": i.password,
            }
        )
    return Response(
        {
            "courses": courses,
        }
    )


@api_view(["POST"])
def institutionDeleteCourse(request):
    data = request.data
    courseId = data["courseId"]
    Courses.objects.filter(
        id=courseId,
    ).delete()
    return Response()
