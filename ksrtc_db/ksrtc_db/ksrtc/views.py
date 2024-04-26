import base64
from datetime import datetime
import io
from rest_framework.response import Response
from rest_framework.decorators import api_view
from institution.models import *
from user.models import *
from PIL import Image, ImageDraw, ImageFont
from django.core.files.base import ContentFile
from .models import *

# Create your views here.


@api_view(["POST"])
def ksrtcGetApplications(request):
    applicationRows = ConcessionForm.objects.filter(
        hodApproval=1,
        institutionApproval=1,
        ksrtcApproval=0,
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
def ksrtcGetApplication(request):
    data = request.data
    aadhar = data["aadhar"]
    row = ConcessionForm.objects.get(
        aadhar=aadhar,
    )
    id = base64.b64encode(row.id.read()).decode("utf-8")
    aadharFront = base64.b64encode(row.aadharFront.read()).decode("utf-8")
    aadharBack = base64.b64encode(row.aadharBack.read()).decode("utf-8")
    application = {
        "id": id,
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
    }
    return Response(
        {
            "application": application,
        }
    )


@api_view(["POST"])
def ksrtcRejectApplication(request):
    data = request.data
    aadhar = data["aadhar"]
    ConcessionForm.objects.filter(
        aadhar=aadhar,
    ).update(
        ksrtcApproval=-1,
    )
    return Response()


@api_view(["POST"])
def ksrtcApproveApplication(request):
    data = request.data
    aadhar = data["aadhar"]
    cost = data["cost"]
    date = data["date"]
    form = ConcessionForm.objects.get(
        aadhar=aadhar,
    )
    name = form.name
    age = form.age
    institution = form.institution
    place = form.place
    district = form.district
    startPoint = form.startPoint
    endPoint = form.endPoint
    photo = Image.open(
        ConcessionForm.objects.get(
            aadhar=aadhar,
        ).photo.path,
    )
    front = Image.open(
        "concession/1.jpg",
    )
    drawFront = ImageDraw.Draw(
        front,
    )
    back = Image.open(
        "concession/2.jpg",
    )
    drawBack = ImageDraw.Draw(
        back,
    )
    font = ImageFont.truetype(
        "fonts/font.ttf",
        50,
    )
    textColor = (
        0,
        0,
        0,
    )
    position = (
        1250,
        390,
    )
    drawFront.text(
        position,
        name,
        fill=textColor,
        font=font,
    )
    position = (
        1250,
        520,
    )
    drawFront.text(
        position,
        age,
        fill=textColor,
        font=font,
    )
    position = (
        1250,
        650,
    )
    drawFront.text(
        position,
        aadhar,
        fill=textColor,
        font=font,
    )
    position = (
        1250,
        780,
    )
    drawFront.text(
        position,
        f"{institution},\n{place},\n{district}",
        fill=textColor,
        font=font,
    )
    position = (
        200,
        350,
    )
    max = 500
    width, height = photo.size
    ratio = width / height
    if width > height:
        width = max
        height = int(max / ratio)
    else:
        height = max
        width = int(max * ratio)
    photo = photo.resize(
        (width, height),
        Image.BICUBIC,
    )
    front.paste(
        photo,
        position,
    )
    position = (
        800,
        310,
    )
    drawBack.text(
        position,
        str(datetime.now().date()),
        fill=textColor,
        font=font,
    )
    position = (
        1700,
        310,
    )
    drawBack.text(
        position,
        date,
        fill=textColor,
        font=font,
    )
    position = (
        600,
        440,
    )
    drawBack.text(
        position,
        startPoint,
        fill=textColor,
        font=font,
    )
    position = (
        1500,
        440,
    )
    drawBack.text(
        position,
        endPoint,
        fill=textColor,
        font=font,
    )
    frontIO = io.BytesIO()
    front.save(
        frontIO,
        format="JPEG",
    )
    form.front.save(
        f"{aadhar}.jpg",
        ContentFile(frontIO.getvalue()),
        save=False,
    )
    backIO = io.BytesIO()
    back.save(
        backIO,
        format="JPEG",
    )
    form.back.save(
        f"{aadhar}.jpg",
        ContentFile(backIO.getvalue()),
        save=False,
    )
    form.save()
    ConcessionForm.objects.filter(
        aadhar=aadhar,
    ).update(
        cost=cost,
        endDate=date,
        ksrtcApproval=1,
    )
    return Response()


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
        photo = base64.b64encode(i.photo.read()).decode("utf-8")
        applications.append(
            {
                "name": i.name,
                "aadhar": i.aadhar,
                "photo": photo,
                "primaryKey": i.primaryKey,
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
    primaryKey = data["primaryKey"]
    row = Concession.objects.get(
        primaryKey=primaryKey,
    )
    id = base64.b64encode(row.id.read()).decode("utf-8")
    aadharFront = base64.b64encode(row.aadharFront.read()).decode("utf-8")
    aadharBack = base64.b64encode(row.aadharBack.read()).decode("utf-8")
    application = {
        "id": id,
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
