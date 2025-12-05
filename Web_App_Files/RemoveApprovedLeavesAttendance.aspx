<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="RemoveApprovedLeavesAttendance.aspx.cs"
    Inherits="UNI.RemoveApprovedLeavesAttendance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

<head runat="server">
    <title>Remove Approved Leave Attendance</title>
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

        .input {
            width: 100%;
            padding: 10px;
            border-radius: 6px;
            border: 1px solid #ffb6d5;
            margin-bottom: 12px;
        }

        .btn {
            padding: 10px 18px;
            border-radius: 6px;
            cursor: pointer;
            border: 1px solid #bbb;
            background: #fafafa;
            margin-top: 10px;
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
            margin-top: 10px;
            display: block;
            text-align: center;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

    <!-- 🌸 ADMIN NAVBAR (Unified Style) -->
    <header class="top-navbar">
        <div class="container">

            <div class="brand"><span class="logo-dot"></span>UniBlossom HR (Admin)</div>

            <ul class="nav">
                <li><a href="AdminHome.aspx">Dashboard</a></li>
            </ul>

            <div class="nav-end">
                <!-- No logout for Admin utility pages -->
            </div>

        </div>
    </header>


    <!-- 🌸 PAGE CONTENT -->
    <div class="container-page">

        <div class="page-title">Remove Approved Leaves from Attendance</div>

        <!-- INPUT CARD -->
        <div class="card-centered">

            <label>Employee ID:</label>
            <asp:TextBox ID="txtEmpID" runat="server" CssClass="input"></asp:TextBox>

            <asp:Button ID="btnRemoveApproved"
                        runat="server"
                        CssClass="btn btn-block"
                        Text="Remove Approved Leaves"
                        OnClick="btnRemoveApproved_Click" />

            <asp:Label ID="lblMessage"
                       runat="server"
                       CssClass="success"
                       Visible="false"></asp:Label>
        </div>


        

    </div>

</form>
</body>
</html>
