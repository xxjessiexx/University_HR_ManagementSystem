<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Attendance Yesterday.aspx.cs" Inherits="UNI.AttendanceYesterday" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Yesterday Attendance</title>
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
        }

        .btn-wide {
            width: 60%;
            margin: auto;
            display: block;
        }

        .table {
            margin-top: 15px;
            border-collapse: collapse;
            width: 100%;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid #ffd5e6;
        }

        .table tr th {
            background: #ffe6f2;
            padding: 10px;
            font-weight: bold;
            color: #d63384;
        }

        .table tr td {
            padding: 10px;
            border-bottom: 1px solid #f9e0ef;
        }

        .table tr:nth-child(even) {
            background: #fff9fc;
        }

        .msg {
            margin-top: 12px;
            font-weight: bold;
            color: #d63333;
        }
    </style>
</head>

<body>
<form id="form1" runat="server">

   <!-- 🌸 ADMIN NAVBAR (MATCHED) -->
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

   <!-- PAGE CONTENT -->
   <div class="container-page">

        <div class="page-title">Yesterday Attendance</div>

        <!-- BUTTON CARD -->
        <div class="card-centered">
            <asp:Button ID="btnLoadAttendance" runat="server" CssClass="btn btn-wide"
                        Text="Show Yesterday Attendance"
                        OnClick="btnLoadAttendance_Click" />
        </div>

        <!-- RESULT CARD -->
        <div class="card-centered" style="margin-top:25px;">
            <asp:GridView ID="GridViewAttendance" runat="server"
                          CssClass="table"
                          AutoGenerateColumns="true"
                          EmptyDataText="No attendance found."
                          GridLines="None">
            </asp:GridView>

            <asp:Label ID="lblMsg" runat="server" CssClass="msg" Visible="false"></asp:Label>
        </div>

   </div>

</form>
</body>
</html>
