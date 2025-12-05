<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminHome.aspx.cs" Inherits="UNI.AdminHome" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="Styles/site.css" />
</head>

<body>
<form id="form1" runat="server">

    <!-- 🌸 FULL ADMIN NAVIGATION BAR -->
    <header class="top-navbar">
        <div class="container">
            <div class="brand">
                <span class="logo-dot"></span>Admin Portal
            </div>

            <ul class="nav">

                <!-- Dashboard -->
                <li><a href="AdminHome.aspx">Dashboard</a></li>

                <!-- EMPLOYEES -->
<li>
    <a class="nav-btn">Employees ▾</a>
    <div class="dropdown-panel">
        <a href="Employees_Details.aspx">View All Employees</a>
        <a href="employee per dep.aspx">Employees Per Department</a>
        <a href="ReplaceEmployee.aspx">Replace Employee</a>
        <a href="UpdateStatus.aspx">Update Employment Status</a> <!-- NEW -->
        <a href="Remove_Deduction_resigned.aspx">Remove Deductions (Resigned)</a>
    </div>
</li>


                <!-- ATTENDANCE -->
                <li>
                    <a class="nav-btn">Attendance ▾</a>
                    <div class="dropdown-panel">
                        <a href="UpdateAttendance.aspx">Update Today’s Attendance</a>
                        <a href="InitiateAttendance.aspx">Initiate Attendance for Today</a>
                        <a href="Attendance Yesterday.aspx">Yesterday’s Attendance</a>
                        <a href="RemoveHolidayAttendance.aspx">Remove Attendance During Holidays</a>
                        <a href="RemoveDayoffAttendance.aspx">Remove Unattended Dayoff</a>
                    </div>
                </li>

                <!-- LEAVES -->
                <li>
                    <a class="nav-btn">Leaves ▾</a>
                    <div class="dropdown-panel">
                        <a href="RejectedMedicals.aspx">Rejected Medical Leaves</a>
                        <a href="RemoveApprovedLeavesAttendance.aspx">Remove Approved Leave</a>
                    </div>
                </li>

                <!-- HOLIDAYS -->
                <li>
                    <a class="nav-btn">Holidays ▾</a>
                    <div class="dropdown-panel">
                        <a href="AddHoliday.aspx">Add New Holiday</a>
                    </div>
                </li>

                <!-- PERFORMANCE -->
                <li>
                    <a class="nav-btn">Performance ▾</a>
                    <div class="dropdown-panel">
                        <a href="PerformanceWinter.aspx">Winter Semester Performance</a>
                    </div>
                </li>

            </ul>

           <div class="nav-end">
    <asp:LinkButton ID="btnLogout" runat="server" CssClass="logout-link"
        OnClick="btnLogout_Click">Logout</asp:LinkButton>
</div>

        </div>
    </header>


    <!-- 🌸 PAGE CONTENT -->
    <div class="container-page">

        <div class="page-title">
    <asp:Label ID="lblWelcome" runat="server"></asp:Label>
</div>


        <div class="card">
            <h3>Admin Overview</h3>
            <p>Use the navigation bar above to perform all administrative tasks.</p>
        </div>


    </div>

</form>
</body>
</html>

