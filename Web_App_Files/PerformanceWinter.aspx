<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PerformanceWinter.aspx.cs" Inherits="UNI.PerformanceWinter" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Winter Performance</title>
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

            <div class="nav-end">
                <!-- No logout here -->
            </div>

        </div>
    </header>


    <!-- 🌸 PAGE CONTENT -->
    <div class="container-page">

        <div class="page-title">Winter Semester Performance</div>

        <!-- LOAD BUTTON CARD -->
        <div class="card-centered">
            <asp:Button ID="btnLoadPerformance" runat="server"
                        Text="Show Winter Performance"
                        CssClass="btn btn-block"
                        OnClick="btnLoadPerformance_Click" />
        </div>

        <!-- TABLE CARD -->
        <div class="card-centered">

            <asp:GridView ID="GridViewPerformance" runat="server"
                          CssClass="table"
                          AutoGenerateColumns="true"
                          EmptyDataText="No Winter performance records found."
                          GridLines="None">
            </asp:GridView>

            <asp:Label ID="lblMessage" runat="server"
                       CssClass="error"
                       Visible="false">
            </asp:Label>
        </div>
    </div>

</form>

</body>
</html>
