# Surgical Intervention and Survival Outcomes in Pancreatic Cancer Patients

### Introduction
	
Pancreatic cancer is one of the most aggressive and fatal cancers, with a 5-year survival rate of only about 10% in the United States [1]. This is primarily due to the fact that pancreatic cancer is often diagnosed at an advanced stage, making it difficult to treat effectively. The American Cancer Society estimates that in 2025, approximately 67,440 people will be diagnosed with pancreatic cancer, and around 51,980 will die from it [2]. Surgery is considered the primary treatment option for patients with localized pancreatic cancer, offering the best chance for survival. However, it is only feasible for a small percentage of patients, as many cases are diagnosed when the cancer has already spread [3]. Several risk factors contribute to the development of pancreatic cancer, including age, sex, tobacco use, and diabetes [4]. 

The primary objective of this study is to compare the survival probabilities between pancreatic cancer patients who have undergone surgery and those who have not. The null hypothesis (H₀) suggests that there is no difference in the survival outcomes of patients who have and have not undergone surgery, while the alternative hypothesis (Hₐ) suggests that there is a significant difference. Additionally, the secondary objective of the study is to explore whether factors such as age, sex, and tumor size influence the survival probability of pancreatic cancer patients, regardless of whether they have had surgery. This study uses data from the SEER 8 Registry (1975-2021) [5], which provides comprehensive information on cancer incidence, survival rates, and treatment outcomes. By examining the impact of surgery and other demographic and clinical factors, this research aims to deepen the understanding of how these variables affect survival in patients with pancreatic cancer and inform future clinical guidelines.

### Methods

This study focused on malignant pancreatic cancer cases diagnosed between 2016 and 2021, with specific inclusion and exclusion criteria to ensure the relevance and reliability of the analysis. Only patients diagnosed with localized or regional-stage pancreatic cancer were included, while those with distant or unknown cancer stage were excluded. Patients with unknown survival months and those under the age of 20 were also excluded. Additionally, patients with unknown race or unmatched rural-urban codes were excluded, leaving a final dataset of 10,848 patients. To control for confounding factors, we performed propensity score matching using the “MatchIt” package, with a caliper of 0.1. Matching was done on key variables including age, sex, race, location (rural-urban continuum code), and cancer stage. This matching process aimed to balance the surgery and non-surgery groups, reducing potential biases and allowing for a more accurate comparison of survival outcomes. Chi-squared tests were used to compare the categorical variables in the matched and unmatched datasets. 

The survival differences between the two groups were analyzed using Kaplan-Meier curves, with the log-rank test to assess statistical significance. Further, we used a Cox proportional hazards (PH) model to explore the effect of various covariates on survival in the full, unmatched dataset. Covariates included age, sex, race, location, tumor size, and chemotherapy. To validate the proportional hazards assumption, we conducted the Schoenfeld residuals test. The final Cox PH model was chosen based on the proportionality test results.

### Results (See Appendix for Tables and Figures)

After matching, chi-squared tests confirmed that baseline characteristics between the surgery and non-surgery groups were well balanced. None of the key covariates showed statistically significant differences post-matching (e.g., age group: p = 0.1099, sex: p = 0.126), indicating that the propensity score matching effectively reduced confounding. In contrast, the unmatched dataset showed some imbalance across these same variables, reinforcing the necessity of matching. Matching results are shown in Table 1. 

Kaplan-Meier survival curves generated from the matched dataset (Figure 1) indicated a pronounced separation between the two groups. Patients who underwent surgery had significantly higher survival probabilities across all time points. The log-rank test confirmed this difference was statistically significant (χ² = 1771, p-value = <2e-16) and the 95% confidence intervals around each curve had no overlap, providing strong visual and statistical evidence that surgery is associated with improved survival among patients with localized or regional pancreatic cancer.

In the full, unmatched dataset, we used a Cox proportional hazards model to evaluate the impact of several covariates on survival. Based on prior findings that indicated differing baseline hazards, the model was stratified on surgery status. To assess whether the proportional hazards assumption held for each covariate, we conducted the Schoenfeld residual test (Table 2). The global test result was highly significant (p < 2e-16), and individual tests revealed significant p-values for age, tumor size, and chemotherapy, suggesting potential violations of the PH assumption. However, in large datasets, even minor and clinically negligible deviations can produce statistically significant test results. Therefore, we examined scaled Schoenfeld residual plots (Figure 2) to evaluate the practical implications of these findings. The smoothed residual lines for age and tumor size remained relatively flat and close to zero, indicating no meaningful deviation from proportionality for these variables. In contrast, chemotherapy displayed a clear time-varying effect, violating the PH assumption. Based on this assessment, our final model retained age and tumor size as fixed covariates, but stratified on both chemotherapy and surgery status. This approach allowed us to control for the non-proportional behavior of chemotherapy while preserving the interpretability of the effects of other variables.

Final Cox model estimates (Table 3) indicated that age was a strong predictor of mortality. Hazard increased steadily with age, with patients aged 80 and above having more than five times the risk of death compared to those under 40 (HR = 5.385, 95% CI: 3.897–7.442, p < 2e-16). Sex was not significantly associated with survival (HR = 1.026, p = 0.316). Race had a notable effect: White (HR = 0.884, p = 0.0059) and Other racial groups (HR = 0.877, p = 0.0146) had lower hazard of death compared to Black patients. Geographic location also played a role. Patients living in smaller metropolitan areas (<250,000 population) had significantly higher hazard compared to those in large metropolitan areas (HR = 1.128, p = 0.0165), while other location categories were not significant. Tumor size had a small but statistically significant effect (HR = 1.0002, p = 0.0004), suggesting that even small increases in tumor size are associated with elevated risk.
Conclusions

Surgical intervention is strongly associated with improved overall survival in pancreatic cancer patients, as evidenced by the significant separation in Kaplan-Meier survival curves and the highly significant log-rank test result. Patients who underwent surgery consistently demonstrated higher survival probabilities compared to those who did not, underscoring the critical role of surgery in managing localized and regional-stage pancreatic cancer. These findings highlight the importance of early detection and timely referral for surgical evaluation, as delays may limit eligibility for potentially life-extending treatment.
Secondary analysis using a Cox proportional hazards model further revealed that age is a strong and consistent predictor of survival, with older patients experiencing substantially higher mortality risk. Additionally, race and geographic location showed moderate but meaningful associations with survival outcomes, pointing to underlying disparities in cancer care access or quality. These results emphasize the urgent need to expand access to surgical oncology services, particularly in underserved or rural communities where patients may face systemic barriers to surgical evaluation and treatment.
Given the use of SEER data, which captures a large and diverse segment of the U.S. population, these findings are broadly generalizable to real-world clinical settings. As such, they have important implications for health systems and policy makers aiming to improve equity, early detection, and access to high-quality surgical care in pancreatic cancer management. 

### References

1.	Mizrahi, J.D., et al., Pancreatic cancer. The Lancet, 2020. 395(10242): p. 2008-2020.
2.	American Cancer Society: https://www.cancer.org/cancer/types/pancreatic-cancer/about/key-statistics.html
3.	Buanes, T.A., Role of surgery in pancreatic cancer. World J Gastroenterol, 2017. 23(21): p. 3765-3770.
4.	Rawla, P., T. Sunkara, and V. Gaduputi, Epidemiology of Pancreatic Cancer: Global Trends, Etiology and Risk Factors. World J Oncol, 2019. 10(1): p. 10-27.
5.	SEER*Stat Database: Incidence - SEER Research Data, 8 Registries, Nov 2023 Sub (1975-2021) - Linked To County Attributes - Time Dependent (1990-2022) Income/Rurality, 1969-2022 Counties, National Cancer Institute, DCCPS, Surveillance Research Program, released April 2024, based on the November 2023 submission.

### Appendix


Table 1. Demographic and Clinical Characteristics of Participants in Matched and Unmatched Groups
	<img width="470" height="213" alt="image" src="https://github.com/user-attachments/assets/600436cf-35bf-459d-b7bb-d044388f08b6" />

Figure 1. Kaplan-Meier Curves by Treatment Group
	<img width="468" height="297" alt="image" src="https://github.com/user-attachments/assets/34426152-ee2d-4097-92c6-6ac9ccf9d28c" />


Table 2. Initial Cox PH Model Schoenfeld Test Results
	<img width="391" height="163" alt="image" src="https://github.com/user-attachments/assets/a6dc8a0c-a3b5-40a8-883d-7fdaf2f80fb6" />

Figure 2. Schoenfeld Residual Plots for Initial Cox PH Model
	<img width="492" height="153" alt="image" src="https://github.com/user-attachments/assets/c4703d37-dd90-4440-8469-e8cc8c293939" />

 

















Table 3. Final Cox PH Model Hazard Ratios

