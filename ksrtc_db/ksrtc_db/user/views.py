import base64
import os
from rest_framework.response import Response
from rest_framework.decorators import api_view
from django.core.mail import send_mail, EmailMessage
import random
from .models import *
from institution.models import *
from ksrtc.models import *
from depot.models import *
import datetime

# Create your views here.


@api_view(["POST"])
def userCheckLogin(request):
    data = request.data
    username = data["username"]
    password = data["password"]
    if User.objects.filter(
        username=username,
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
def userCheckUsername(request):
    data = request.data
    username = data["username"]
    email = data["email"]
    if User.objects.filter(
        username=username,
    ).exists():
        return Response(
            {
                "status": 1,
            }
        )
    if User.objects.filter(
        email=email,
    ).exists():
        return Response(
            {
                "status": 2,
            }
        )
    otp = random.randint(100000, 999999)
    subject = "Ksrtc Concession Signup Otp"
    message = "You Otp For Signing Up For Ksrtc Concession App Is " + str(otp)
    sender = "ksrtc.concession@gmail.com"
    receiver = [email]
    if Otp.objects.filter(
        username=username,
    ).exists():
        Otp.objects.filter(
            username=username,
        ).update(otp=otp)
    else:
        Otp.objects.create(
            username=username,
            otp=otp,
        )
    send_mail(
        subject,
        message,
        sender,
        receiver,
    )
    return Response(
        {
            "status": 0,
        }
    )


@api_view(["POST"])
def userSignup(request):
    data = request.data
    name = data["name"]
    username = data["username"]
    email = data["email"]
    password = data["password"]
    otp = data["otp"]
    if Otp.objects.filter(
        username=username,
        otp=otp,
    ).exists():
        Otp.objects.filter(
            username=username,
        ).delete()
        User.objects.create(
            name=name,
            username=username,
            email=email,
            password=password,
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
def userSignupResend(request):
    data = request.data
    username = data["username"]
    email = data["email"]
    otp = random.randint(100000, 999999)
    subject = "Ksrtc Concession Signup Otp"
    message = "You Otp For Signing Up For Ksrtc Concession App Is " + str(otp)
    sender = "ksrtc.concession@gmail.com"
    receiver = [email]
    if Otp.objects.filter(
        username=username,
    ).exists():
        Otp.objects.filter(
            username=username,
        ).update(
            otp=otp,
        )
    else:
        Otp.objects.create(
            username=username,
            otp=otp,
        )
    send_mail(
        subject,
        message,
        sender,
        receiver,
    )
    return Response(
        {
            "status": True,
        }
    )


@api_view(["POST"])
def userGetProfile(request):
    data = request.data
    username = data["username"]
    name = User.objects.get(
        username=username,
    ).name
    email = User.objects.get(
        username=username,
    ).email
    return Response(
        {
            "name": name,
            "email": email,
        }
    )


@api_view(["POST"])
def userForgotPassword(request):
    data = request.data
    id = data["id"]
    otp = random.randint(100000, 999999)
    subject = "Ksrtc Concession Password Reset Otp"
    message = "You Otp For Resetting Password Of Ksrtc Concession App Is " + str(otp)
    sender = "ksrtc.concession@gmail.com"
    if User.objects.filter(
        username=id,
    ).exists():
        email = User.objects.get(
            username=id,
        ).email
        if Otp.objects.filter(
            username=id,
        ).exists():
            Otp.objects.filter(
                username=id,
            ).update(
                otp=otp,
            )
        else:
            Otp.objects.create(
                username=id,
                otp=otp,
            )
        send_mail(
            subject,
            message,
            sender,
            [email],
        )
        return Response(
            {
                "status": True,
                "username": id,
            }
        )
    if User.objects.filter(
        email=id,
    ).exists():
        username = User.objects.get(
            email=id,
        ).username
        if Otp.objects.filter(
            username=username,
        ).exists():
            Otp.objects.filter(
                username=username,
            ).update(
                otp=otp,
            )
        else:
            Otp.objects.create(
                username=username,
                otp=otp,
            )
        send_mail(
            subject,
            message,
            sender,
            [id],
        )
        return Response(
            {
                "status": True,
                "username": username,
            }
        )
    return Response(
        {
            "status": False,
        }
    )


@api_view(["POST"])
def userOtpCheck(request):
    data = request.data
    username = data["username"]
    otp = data["otp"]
    if Otp.objects.filter(
        username=username,
        otp=otp,
    ).exists():
        Otp.objects.filter(
            username=username,
        ).delete()
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
def userForgotPasswordChange(request):
    data = request.data
    username = data["username"]
    password = data["password"]
    User.objects.filter(
        username=username,
    ).update(
        password=password,
    )
    return Response()


@api_view(["POST"])
def userUpdateProfile(request):
    data = request.data
    _username = data["_username"]
    name = data["name"]
    username = data["username"]
    email = data["email"]
    if username != _username:
        if User.objects.filter(
            username=username,
        ).exists():
            return Response(
                {
                    "status": 1,
                }
            )
    if User.objects.filter(
        email=email,
    ).exists():
        if (
            User.objects.get(
                email=email,
            ).username
            != _username
        ):
            return Response(
                {
                    "status": 2,
                }
            )
    if (
        User.objects.get(
            username=_username,
        ).email
        != email
    ):
        otp = random.randint(100000, 999999)
        subject = "Ksrtc Concession Change Email Otp"
        message = "You Otp For Changing Email Of Ksrtc Concession App Is " + str(otp)
        sender = "ksrtc.concession@gmail.com"
        if Otp.objects.filter(
            username=_username,
        ).exists():
            Otp.objects.filter(
                username=_username,
            ).update(
                otp=otp,
            )
        else:
            Otp.objects.create(
                username=_username,
                otp=otp,
            )
        send_mail(
            subject,
            message,
            sender,
            [email],
        )
        return Response({"status": -1})
    User.objects.filter(
        username=_username,
    ).update(
        name=name,
    )
    User.objects.filter(
        username=_username,
    ).update(
        username=username,
    )
    return Response(
        {
            "status": 0,
        }
    )


@api_view(["POST"])
def userUpdateProfileOtp(request):
    data = request.data
    _username = data["_username"]
    name = data["name"]
    username = data["username"]
    email = data["email"]
    otp = data["otp"]
    if Otp.objects.filter(
        username=_username,
        otp=otp,
    ).exists():
        User.objects.filter(
            username=_username,
        ).update(
            name=name,
            username=username,
            email=email,
        )
        Otp.objects.filter(
            username=_username,
        ).delete()
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
def userChangePassword(request):
    data = request.data
    username = data["username"]
    password = data["password"]
    newPassword = data["newPassword"]
    if User.objects.filter(
        username=username,
        password=password,
    ).exists():
        User.objects.filter(
            username=username,
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
def userGetDepots(request):
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
def userGetPlaces(request):
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
def userGetInstitutions(request):
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
def userGetCourses(request):
    data = request.data
    district = data["district"]
    place = data["place"]
    institution = data["institution"]
    id = Institutions.objects.get(
        district=district,
        place=place,
        institution=institution,
    ).id
    courses = Courses.objects.filter(
        institutionId=id,
    ).values_list(
        "course",
        flat=True,
    )
    return Response(
        {
            "courses": courses,
        }
    )


@api_view(["POST"])
def userApplyConcession(request):
    data = request.data
    username = data["username"]
    name = data["name"]
    age = data["age"]
    aadhar = data["aadhar"]
    startPoint = data["startPoint"]
    endPoint = data["endPoint"]
    rate = data["rate"]
    homeDistrict = data["homeDistrict"]
    depot = data["depot"]
    district = data["district"]
    place = data["place"]
    institution = data["institution"]
    course = data["course"]
    photo = data["photo"]
    idCard = data["id"]
    aadharFront = data["aadharFront"]
    aadharBack = data["aadharBack"]
    if ConcessionForm.objects.filter(
        aadhar=aadhar,
    ).exists():
        return Response({"status": 1})
    if Concession.objects.filter(
        aadhar=aadhar,
    ).exists():
        today = datetime.date.today()
        endDate = (
            Concession.objects.filter(
                aadhar=aadhar,
            )
            .latest("endDate")
            .endDate
        )
        if today < endDate:
            return Response({"status": 2})
    ConcessionForm.objects.create(
        username=username,
        name=name.upper(),
        age=age,
        aadhar=aadhar,
        startPoint=startPoint.upper(),
        endPoint=endPoint.upper(),
        rate=rate,
        homeDistrict=homeDistrict,
        depot=depot,
        district=district,
        place=place,
        institution=institution,
        course=course,
        photo=photo,
        idCard=idCard,
        aadharFront=aadharFront,
        aadharBack=aadharBack,
    )
    return Response(
        {
            "status": 0,
        }
    )


@api_view(["POST"])
def userGetApplications(request):
    data = request.data
    username = data["username"]
    applicationRows = ConcessionForm.objects.filter(
        username=username,
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
def userGetApplication(request):
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
        "homeDistrict": row.homeDistrict,
        "depot": row.depot,
        "district": row.district,
        "place": row.place,
        "institution": row.institution,
        "course": row.course,
        "hodApproval": row.hodApproval,
        "institutionApproval": row.institutionApproval,
        "ksrtcApproval": row.ksrtcApproval,
        "cost": row.cost,
    }
    return Response(
        {
            "application": application,
        }
    )


@api_view(["POST"])
def userDeleteApplication(request):
    data = request.data
    aadhar = data["aadhar"]
    form = ConcessionForm.objects.get(
        aadhar=aadhar,
    )
    os.remove(form.photo.path)
    os.remove(form.id.path)
    os.remove(form.aadharFront.path)
    os.remove(form.aadharBack.path)
    ConcessionForm.objects.filter(
        aadhar=aadhar,
    ).delete()
    return Response()


@api_view(["POST"])
def userPay(request):
    data = request.data
    aadhar = data["aadhar"]
    form = ConcessionForm.objects.get(
        aadhar=aadhar,
    )
    Concession.objects.create(
        username=form.username,
        photo=form.photo,
        idCard=form.idCard,
        name=form.name,
        aadhar=aadhar,
        age=form.age,
        aadharFront=form.aadharFront,
        aadharBack=form.aadharBack,
        startPoint=form.startPoint,
        endPoint=form.endPoint,
        rate=form.rate,
        course=form.course,
        homeDistrict=form.homeDistrict,
        depot=form.depot,
        district=form.district,
        place=form.place,
        institution=form.institution,
        front=form.front,
        back=form.back,
        endDate=form.endDate,
        cost=form.cost,
    )
    username = form.username
    email = User.objects.get(
        username=username,
    ).email
    subject = "Ksrtc Concession"
    message = "Your Concession"
    sender = "ksrtc.concession@gmail.com"
    receiver = [email]
    mail = EmailMessage(
        subject,
        message,
        sender,
        receiver,
    )
    with open(form.front.path, "rb") as front:
        mail.attach(
            "front.jpg",
            front.read(),
            "image/jpg",
        )
    with open(form.back.path, "rb") as back:
        mail.attach(
            "back.jpg",
            back.read(),
            "image/jpg",
        )
    ConcessionForm.objects.filter(
        aadhar=aadhar,
    ).delete()
    mail.send()
    return Response()


@api_view(["POST"])
def userGetCompletedApplications(request):
    data = request.data
    username = data["username"]
    applicationRows = Concession.objects.filter(
        username=username,
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
def userGetCompletedApplication(request):
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
    }
    return Response(
        {
            "application": application,
        }
    )


@api_view(["POST"])
def userDownloadConcession(request):
    data = request.data
    id = data["id"]
    concession = Concession.objects.get(
        id=id,
    )
    username = concession.username
    email = User.objects.get(
        username=username,
    ).email
    subject = "Ksrtc Concession"
    message = "Your Concession"
    sender = "ksrtc.concession@gmail.com"
    receiver = [email]
    mail = EmailMessage(
        subject,
        message,
        sender,
        receiver,
    )
    with open(concession.front.path, "rb") as front:
        mail.attach(
            "front.jpg",
            front.read(),
            "image/jpg",
        )
    with open(concession.back.path, "rb") as back:
        mail.attach(
            "back.jpg",
            back.read(),
            "image/jpg",
        )
    mail.send()
    return Response()
