<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SubmitUnpaidLeave.aspx.cs" Inherits="UNI.SubmitUnpaidLeave" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Submit Unpaid Leave</title>
<link rel="stylesheet" href="Styles/site.css" />
</head>
<body>
    <form id="form1" runat="server">
        <!--navbar-->
        <header class="top-navbar">
    <div class="container">
        <div class="brand">
            <span class="logo-dot"></span> UniBlossom HR
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
         <div class="container-page">

     <div class="page-title">Submit Unpaid Leave</div>

     <div class="card">
         <label>Employee ID</label>
         <asp:TextBox ID="empId" runat="server"></asp:TextBox>

         <label>Start Date</label>
         <asp:TextBox ID="sdate" runat="server" TextMode="Date"></asp:TextBox>

         <label>End Date</label>
         <asp:TextBox ID="edate" runat="server" TextMode="Date"></asp:TextBox>

         <label>Submitted Document Description</label>
         <asp:TextBox ID="doc_des" runat="server" Width="150px"></asp:TextBox>

         <label>File Name</label>
         <asp:TextBox ID="file_name" runat="server" Width="150px"></asp:TextBox>

         <asp:Button ID="btnSubmitLeave" runat="server" Text="Submit Leave" CssClass="btn" OnClick="Submit_unpaid" />
         <br />
         <asp:Label ID="mssg" runat="server" Visible="false"></asp:Label>
     </div>
 </div>
    </form>
</body>
</html>
