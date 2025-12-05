using System;

namespace UNI
{
    public partial class AdminHome : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["IsAdmin"] == null || !(bool)Session["IsAdmin"])
            {
                Response.Redirect("~/AdminLogin.aspx");
                return;
            }

            if (!IsPostBack)
                lblWelcome.Text = "Welcome, " + Session["AdminID"];
        }

        protected void btnEmp_Click(object sender, EventArgs e) => Response.Redirect("~/Employees_Details.aspx");
        protected void btnDept_Click(object sender, EventArgs e) => Response.Redirect("~/employee per dep.aspx");
        protected void btnRejected_Click(object sender, EventArgs e) => Response.Redirect("~/RejectedMedicals.aspx");
        protected void btnDeductions_Click(object sender, EventArgs e) => Response.Redirect("~/Remove_Deduction_resigned.aspx");

        protected void btnUpdate_Click(object sender, EventArgs e) => Response.Redirect("~/UpdateAttendance.aspx");
        protected void btnHoliday_Click(object sender, EventArgs e) => Response.Redirect("~/AddHoliday.aspx");
        protected void btnInitiate_Click(object sender, EventArgs e) => Response.Redirect("~/InitiateAttendance.aspx");

        // ⭐ NEW BUTTON HERE ⭐
        protected void btnUpdateStatus_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/UpdateStatus.aspx");
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("~/AdminLogin.aspx");
        }
    }
}
