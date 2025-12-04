<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyAttendance.aspx.cs" Inherits="HR.MyAttendance" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>My Attendance</title>
    <link rel="stylesheet" href="Styles/site.css" />
</head>

<body>
<form id="form1" runat="server">

    <!-- 🌸 SAKURA NAVBAR -->
    <header class="top-navbar">
        <div class="container">
            <div class="brand"><span class="logo-dot"></span>UniBlossom HR</div>

            <ul class="nav">
                <li><a href="EmployeeHome.aspx">Dashboard</a></li>

                <li>
                    <a class="nav-btn">Attendance ▾</a>
                    <div class="dropdown-panel">
                        <a href="MyAttendance.aspx">My Attendance</a>
                        <a href="MyDeductions.aspx">My Deductions</a>
                    </div>
                </li>

                <li><a href="MyPayroll.aspx">Payroll</a></li>
                <li><a href="MyPerformance.aspx">Performance</a></li>

                <li>
                    <a class="nav-btn">Leaves ▾</a>
                    <div class="dropdown-panel">
                        <a href="SubmitAnnualLeave.aspx">Submit Annual Leave</a>
                        <a href="LeaveStatus.aspx">Leave Status</a>
                    </div>
                </li>

                <li><a href="MyDeductions.aspx">Deductions</a></li>
            </ul>

            <div class="nav-end">
                <a href="LogIn.aspx">Logout</a>
            </div>
        </div>
    </header>

    <!-- 🌸 PAGE CONTENT -->
    <div class="container-page">
        <div class="page-title">My Attendance</div>

        <div class="card">
            <asp:Button ID="btnGetAttendance" runat="server" CssClass="btn"
                        Text="Load Attendance"
                        OnClick="GetAttendance_Click" />

            <asp:Label ID="errorLabel" runat="server" Visible="false"
                       CssClass="error" />
        </div>

        <div class="card">
            <asp:GridView ID="gvAttendance" runat="server" CssClass="table"
                          AutoGenerateColumns="true"></asp:GridView>
        </div>
    </div>

</form>
</body>
</html>
