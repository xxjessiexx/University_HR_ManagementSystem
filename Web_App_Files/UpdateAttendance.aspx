<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UpdateAttendance.aspx.cs" Inherits="UNI.UpdateAttendance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Update Attendance - Admin</title>
    <link rel="stylesheet" href="Styles/site.css" />

    <style>
        /* CARD STYLE */
        .form-card {
            background: #ffffff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 25px;
            border: 1px solid #eee;
            width: 100%;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
        }

        .page-title {
            font-size: 26px;
            font-weight: 700;
            margin-bottom: 22px;
        }

        .form-row {
            margin: 14px 0;
            display: flex;
            align-items: center;
        }

        .form-row label {
            width: 180px;
            font-weight: 600;
            color: #444;
        }

        .form-row input[type="text"],
        .form-row input[type="time"] {
            padding: 8px;
            width: 200px;
            border: 1px solid #ccc;
            border-radius: 5px;
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

        .small {
            font-size: 0.9em;
            color: #666;
            margin-left: 10px;
        }

        .msg {
            color: #c0392b;
            font-weight: 600;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- ▬▬▬▬▬▬▬▬▬ ADMIN NAVBAR WITH LOGOUT ▬▬▬▬▬▬▬▬▬ -->
    <header class="top-navbar">
        <div class="container">

            <div class="brand">
                <span class="logo-dot"></span>UniBlossom HR (Admin)
            </div>

            <ul class="nav">
                <li><a href="AdminHome.aspx">Dashboard</a></li>
            </ul>

            <div class="nav-end">
                <a href="AdminLogin.aspx">Logout</a>
            </div>

        </div>
    </header>

    <!-- ▬▬▬▬▬▬▬▬▬ PAGE CONTENT ▬▬▬▬▬▬▬▬▬ -->
    <div class="container-page">

        <div class="page-title">Update Attendance for Today</div>

        <!-- MAIN CARD -->
        <div class="form-card">

            <asp:Label ID="lblMsg" runat="server" CssClass="msg" />

            <!-- EMPLOYEE ID -->
            <div class="form-row">
                <label for="txtEmpID">Employee ID:</label>
                <asp:TextBox ID="txtEmpID" runat="server" Width="200px" />
                <span class="small">Enter numeric employee_id</span>
            </div>

            <!-- CHECK-IN -->
            <div class="form-row">
                <label for="txtCheckIn">Check-in Time:</label>
                <asp:TextBox ID="txtCheckIn" runat="server" TextMode="Time" Width="200px" />
                <span class="small">Format HH:mm</span>
            </div>

            <!-- CHECK-OUT -->
            <div class="form-row">
                <label for="txtCheckOut">Check-out Time:</label>
                <asp:TextBox ID="txtCheckOut" runat="server" TextMode="Time" Width="200px" />
                <span class="small">Format HH:mm</span>
            </div>

            <!-- BUTTONS -->
            <div style="margin-top:18px;">
                <asp:Button ID="btnUpdate" runat="server" Text="Update Attendance" CssClass="btn" OnClick="btnUpdate_Click" />
                &nbsp;
                <asp:Button ID="btnBack" runat="server" Text="Back to Admin Home" CssClass="btn" OnClick="btnBack_Click" />
            </div>

            <br />
           

        </div>

    </div>

</form>
</body>
</html>

