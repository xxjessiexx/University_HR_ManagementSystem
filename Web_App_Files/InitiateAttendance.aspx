<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InitiateAttendance.aspx.cs" Inherits="UNI.InitiateAttendance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Initiate Attendance - Admin</title>
    <link rel="stylesheet" href="Styles/site.css" />

    <style>
        /* Sakura card styling */
        .form-card {
            background: #ffffff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            border: 1px solid #eee;
            margin-bottom: 25px;
        }

        .btn {
            padding: 10px 18px;
            border-radius: 6px;
            border: 1px solid #bbb;
            background: #fafafa;
            cursor: pointer;
        }

        .btn:hover {
            background: #f0e9ff;
            border-color: #c6b8f7;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- 🌸 Admin Sakura Navbar (NO LOGOUT) -->
    <header class="top-navbar">
        <div class="container">

            <div class="brand">
                <span class="logo-dot"></span>
                UniBlossom HR (Admin)
            </div>

            <ul class="nav">
                <li><a href="AdminHome.aspx">Dashboard</a></li>
            </ul>

        </div>
    </header>

    <!-- 🌸 PAGE CONTENT -->
    <div class="container-page">

        <div class="page-title">Initiate Attendance Records</div>

        <!-- Styled Card -->
        <div class="form-card">

            <asp:Label ID="lblMsg" runat="server" ForeColor="Red"></asp:Label>

            <p>
                Click the button below to insert an attendance row for every employee
                who does not already have an attendance record for today.
            </p>

            <br />

            <asp:Button ID="btnInitiate" runat="server"
                        Text="Initiate Attendance for Today"
                        CssClass="btn"
                        OnClick="btnInitiate_Click" />

            &nbsp;

            <asp:Button ID="btnBack" runat="server"
                        Text="Back to Admin Home"
                        CssClass="btn"
                        OnClick="btnBack_Click" />

        </div>

    </div>

</form>
</body>
</html>
