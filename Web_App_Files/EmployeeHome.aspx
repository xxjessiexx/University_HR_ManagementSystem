<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmployeeHome.aspx.cs" Inherits="HR.EmployeeHome" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Employee Dashboard</title>
    <link rel="stylesheet" href="Styles/site.css" />
</head>

<body>
<form id="form1" runat="server">

    <!-- ▬▬▬▬▬▬▬▬▬ Sakura Navbar ▬▬▬▬▬▬▬▬▬ -->
    <header class="top-navbar">
        <div class="container">
            <div class="brand">
                <span class="logo-dot"></span>UniBlossom HR
            </div>
            <ul class="nav">
    <li><a href="EmployeeHome.aspx">Dashboard</a></li>

    <li>
        <a href="#" class="nav-btn">Attendance ▾</a>
        <div class="dropdown-panel">
            <a href="MyAttendance.aspx">My Attendance</a>
            <a href="MyDeductions.aspx">My Deductions</a>
        </div>
    </li>

    <li><a href="MyPayroll.aspx">Payroll</a></li>
    <li><a href="MyPerformance.aspx">Performance</a></li>

    <li>
        <a href="#" class="nav-btn">Leaves ▾</a>
        <div class="dropdown-panel">
            <a href="SubmitAnnualLeave.aspx">Submit Annual Leave</a>
            <a href="SubmitAccidentalLeave.aspx">Submit Accidental Leave</a>
            <a href="SubmitCompensationLeave.aspx">Submit Compensation Leave</a>
            <a href="SubmitMedicalLeave.aspx">Submit Medical Leave</a>
            <a href="SubmitUnpaidLeave.aspx">Submit Unpaid Leave</a>
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

    <!-- ▬▬▬▬▬▬▬▬▬ Dashboard Content ▬▬▬▬▬▬▬▬▬ -->
    <div class="container-page">

        <div class="page-title">Welcome, 
            <asp:Label ID="empName" runat="server" />
        </div>

        <!-- Quick action cards -->
        <div class="card">
            <h3>Quick Links</h3>
            <p>Select any option from the navigation bar to view your HR information.</p>
        </div>

        <div class="card">
            <h3>Your HR Services Include:</h3>
            <ul style="margin-left:18px; line-height:1.8;">
                <li>✔ View Attendance & Monthly Deductions</li>
                <li>✔ View Last Month Payroll</li>
                <li>✔ Submit Annual Leave Requests</li>
                <li>✔ Track Leave Status</li>
                <li>✔ See Performance Reports</li>
            </ul>
        </div>

    </div>

</form>
</body>
</html>
