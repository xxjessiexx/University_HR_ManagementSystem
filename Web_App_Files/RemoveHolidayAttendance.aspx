<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RemoveHolidayAttendance.aspx.cs" Inherits="UNI.RemoveHolidayAttendance" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Remove Holiday Attendance</title>
    <link rel="stylesheet" href="Styles/site.css" />

    <style>
        .card-centered {
            max-width: 850px;
            margin: auto;
            padding: 25px;
            border-radius: 12px;
            background: #ffffff;
            border: 1px solid #f6d8ea;
            box-shadow: 0 3px 10px rgba(255, 105, 180, 0.12);
            margin-bottom: 25px;
        }

        .btn {
            padding: 10px 18px;
            border-radius: 6px;
            cursor: pointer;
            border: 1px solid #bbb;
            background: #fafafa;
        }

        .btn:hover {
            background: #f0e9ff;
            border-color: #c6b8f7;
        }

        .btn-block {
            display: block;
            width: 60%;
            margin: 10px auto;
        }

        .success {
            color: green;
            font-weight: bold;
            display: block;
            margin-top: 12px;
            text-align: center;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- 🌸 ADMIN NAVBAR -->
    <header class="top-navbar">
        <div class="container">

            <div class="brand">
                <span class="logo-dot"></span>UniBlossom HR (Admin)
            </div>

            <ul class="nav">
                <li><a href="AdminHome.aspx">Dashboard</a></li>
            </ul>

            <div class="nav-end"></div>
        </div>
    </header>

    <!-- 🌸 PAGE CONTENT -->
    <div class="container-page">

        <div class="page-title">Remove Attendance During Official Holidays</div>

        <!-- ACTION CARD -->
        <div class="card-centered">
            <asp:Button 
                ID="btnRemove" 
                runat="server"
                CssClass="btn btn-block"
                Text="Remove Holiday Attendance"
                OnClick="btnRemove_Click" />

            <asp:Label 
                ID="lblMessage" 
                runat="server"
                Visible="false"
                CssClass="success">
            </asp:Label>
        </div>

        
    </div>

</form>
</body>
</html>

