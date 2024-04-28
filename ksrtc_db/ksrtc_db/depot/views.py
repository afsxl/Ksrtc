import base64
import io
from rest_framework.response import Response
from rest_framework.decorators import api_view
from .models import *
from user.models import *
from datetime import datetime
from django.core.files.base import ContentFile
from PIL import Image, ImageDraw, ImageFont
from ksrtc.models import *


@api_view(["POST"])
def depotCheckLogin(request):
    data = request.data
    id = data["id"]
    password = data["password"]
    if Depots.objects.filter(
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
def depotGetDepots(request):
    data = request.data
    district = data["district"]
    depots = Depots.objects.filter(
        district=district,
    ).values_list(
        "depot",
        flat=True,
    )
    depots = list(depots)
    return Response(
        {
            "depots": depots,
        }
    )


@api_view(["POST"])
def depotSignin(request):
    data = request.data
    district = data["district"]
    depot = data["depot"]
    password = data["password"]
    depotId = Depots.objects.get(
        district=district,
        depot=depot,
    ).id
    if Depots.objects.filter(
        id=depotId,
        password=password,
    ).exists():
        return Response(
            {
                "id": depotId,
                "status": True,
            }
        )
    return Response(
        {
            "status": False,
        }
    )


@api_view(["POST"])
def depotGetProfile(request):
    data = request.data
    id = data["id"]
    depot = Depots.objects.get(
        id=id,
    ).depot
    district = Depots.objects.get(
        id=id,
    ).district
    profile = {
        "depot": depot,
        "district": district,
    }
    return Response(
        {
            "profile": profile,
        }
    )


@api_view(["POST"])
def depotChangePassword(request):
    data = request.data
    id = data["id"]
    password = data["password"]
    newPassword = data["newPassword"]
    if Depots.objects.filter(
        id=id,
        password=password,
    ).exists():
        Depots.objects.filter(
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
def depotGetApplications(request):
    applicationRows = ConcessionForm.objects.filter(
        hodApproval=1,
        institutionApproval=1,
        ksrtcApproval=0,
    ).all()
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
            }
        )
    return Response(
        {
            "applications": applications,
        }
    )


@api_view(["POST"])
def depotGetApplication(request):
    data = request.data
    aadhar = data["aadhar"]
    row = ConcessionForm.objects.get(
        aadhar=aadhar,
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
        "depot": row.depot,
        "homeDistrict": row.homeDistrict,
    }
    return Response(
        {
            "application": application,
        }
    )


@api_view(["POST"])
def depotRejectApplication(request):
    data = request.data
    aadhar = data["aadhar"]
    ConcessionForm.objects.filter(
        aadhar=aadhar,
    ).update(
        ksrtcApproval=-1,
    )
    return Response()


@api_view(["POST"])
def depotApproveApplication(request):
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
        str(
            datetime.now().date(),
        ),
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
        ContentFile(
            frontIO.getvalue(),
        ),
        save=False,
    )
    backIO = io.BytesIO()
    back.save(
        backIO,
        format="JPEG",
    )
    form.back.save(
        f"{aadhar}.jpg",
        ContentFile(
            backIO.getvalue(),
        ),
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
def depotGetCompletedApplications(request):
    data = request.data
    id = data["id"]
    district = Depots.objects.get(
        id=id,
    ).district
    depot = Depots.objects.get(
        id=id,
    ).depot
    applicationRows = Concession.objects.filter(
        district=district,
        depot=depot,
    ).all()
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
def depotGetCompletedApplication(request):
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
        "homeDistrict": row.homeDistrict,
        "depot": row.depot,
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
